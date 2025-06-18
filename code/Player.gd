extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

@onready var camera = $Camera3D
@onready var ray = $Camera3D/interactRange
@onready var interaction_text = %HUD/Interact
@onready var game_state = %GameState

var current_interactable = null
var is_ready = false

func _ready():
	# Verify required nodes exist
	if !camera or !ray:
		push_error("Required child nodes not found!")
		return
	if !interaction_text or !game_state:
		push_error("Required UI or GameState nodes not found!")
		return
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_text.visible = false
	is_ready = true

func _exit_tree():
	# Ensure mouse is released when scene changes
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event):
	if !is_ready:
		return
		
	# Handle mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Handle interaction inputs
	if event.is_action_pressed("interact"): # E key
		_handle_interaction()
	
	elif event.is_action_pressed("accuse"): # Q key
		_handle_accusation()
	
	# Toggle mouse capture with Escape
	if event.is_action_pressed("ui_cancel"):
		_toggle_mouse_capture()

func _toggle_mouse_capture():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if !is_ready:
		return
		
	var input_dir = Input.get_vector("left", "right", "backward", "forward")
	
	# Get the forward and right directions relative to the camera
	var forward = -camera.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	
	var right = camera.global_transform.basis.x
	right.y = 0
	right = right.normalized()
	
	var direction = (forward * input_dir.y + right * input_dir.x)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	_check_ray_collision()

func _check_ray_collision():
	if !ray.is_colliding():
		_clear_interaction()
		return
		
	var collider = ray.get_collider()
	if !is_instance_valid(collider):
		_clear_interaction()
		return
		
	if collider.get_parent() is Interractable:
		_handle_interactable_hover(collider.get_parent())
	elif collider.get_parent() is cha:
			_handle_character_hover()

func _handle_interaction():
	if !ray.is_colliding():
		return
		
	var collider = ray.get_collider()
	if !is_instance_valid(collider):
		return
		
	if game_state.current_phase == game_state.Phase.RESEARCH:
		if collider is Interractable:
			collider.interact()
		elif collider.get_parent() is Interractable:
			collider.get_parent().interact()
	elif game_state.current_phase == game_state.Phase.JUDGEMENT:
		if collider.is_in_group("characters"):
			collider.listen()

func _handle_accusation():
	if game_state.current_phase != game_state.Phase.JUDGEMENT:
		return
		
	if !ray.is_colliding() or !is_instance_valid(ray.get_collider()):
		return
		
	var collider = ray.get_collider()
	if collider.is_in_group("characters"):
		game_state.make_accusation(collider)

func _handle_interactable_hover(interactable):
	if !is_instance_valid(interactable):
		_clear_interaction()
		return
		
	if current_interactable != interactable:
		_clear_interaction()
		current_interactable = interactable
		current_interactable.enable_highlight()
		interaction_text.text = "Press E to inspect"
		interaction_text.visible = true

func _handle_character_hover():
	_clear_interaction()
	interaction_text.text = "E: Listen\nQ: Accuse"
	interaction_text.visible = true

func _clear_interaction():
	if is_instance_valid(current_interactable):
		current_interactable.disable_highlight()
	current_interactable = null
	if is_instance_valid(interaction_text):
		interaction_text.visible = false
