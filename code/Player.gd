extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

@onready var camera = $Camera3D
@onready var ray = $Camera3D/interactRange
@onready var interaction_text = %HUD/Interact
@onready var game_state = %GameState

var current_interactable = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_text.visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	elif event.is_action_pressed("interact"): # E key
		_handle_interaction()
	
	elif event.is_action_pressed("accuse"): # Q key
		_handle_accusation()

func _physics_process(_delta):
	_handle_movement()
	_check_ray_collision()

func _handle_movement():
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity = Vector3(direction.x * SPEED, 0, direction.z * SPEED)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, SPEED)
	
	move_and_slide()

func _check_ray_collision():
	if ray.is_colliding():
		var collider = ray.get_collider()
		
		if game_state.current_phase == game_state.Phase.RESEARCH:
			if collider is Interractable:
				_handle_interactable_hover(collider)
				return
		
		elif game_state.current_phase == game_state.Phase.JUDGEMENT:
			if collider.is_in_group("characters"):
				_handle_character_hover()
				return
	
	_clear_interaction()

func _handle_interaction():
	if not ray.is_colliding():
		return
		
	var collider = ray.get_collider()
	
	if game_state.current_phase == game_state.Phase.RESEARCH:
		if collider is Interractable:
			collider.interact()
	elif game_state.current_phase == game_state.Phase.JUDGEMENT:
		if collider.is_in_group("characters"):
			collider.listen()

func _handle_accusation():
	if game_state.current_phase != game_state.Phase.JUDGEMENT:
		return
		
	if ray.is_colliding() and ray.get_collider().is_in_group("characters"):
		game_state.make_accusation(ray.get_collider().get_parent())

func _handle_interactable_hover(interactable):
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
	if current_interactable:
		current_interactable.disable_highlight()
		current_interactable = null
	interaction_text.visible = false
