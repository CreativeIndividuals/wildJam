extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

@onready var camera = $Camera3D
@onready var ray = $Camera3D/interactRange
@onready var interaction_text = %Interact
@onready var game_state = %GameState
var current_interactable:Interractable = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_text.visible = false

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Interaction inputs
	if event.is_action_pressed("interact"): # E key
		handle_interaction()
	elif event.is_action_pressed("accuse"): # Q key
		handle_accusation()
	
	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	# Movement
	var input_dir = Input.get_vector("left", "right", "backward", "forward")
	
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
	check_interaction_target()

func check_interaction_target():
	if !ray.is_colliding():
		clear_interaction_target()
		return
	var target = ray.get_collider()

	if target.is_in_group("clues"):
		if current_interactable != target:
			# Disable highlight on the previous clue
			if is_instance_valid(current_interactable):
				current_interactable.disable_highlight()
			current_interactable = target
			current_interactable.enable_highlight()
		show_interaction_prompt("Press E to inspect")
	elif target.is_in_group("characters"):
		# Disable highlight if we were highlighting a clue
		if is_instance_valid(current_interactable):
			current_interactable.disable_highlight()
			current_interactable = null
		show_interaction_prompt("E: Listen\nQ: Accuse")
	else:
		clear_interaction_target()

func handle_interaction():
	if !ray.is_colliding():
		return

	var target = ray.get_collider()
	var parent = target
	if !parent.is_in_group("clues") and !parent.is_in_group("characters"):
		parent = target.get_parent()

	if game_state.current_phase == game_state.Phase.RESEARCH:
		if parent.is_in_group("clues"):
			parent.interact()
	elif game_state.current_phase == game_state.Phase.JUDGEMENT:
		if parent.is_in_group("characters"):
			parent.listen()

func handle_accusation():
	if !ray.is_colliding():
		return
	var target = ray.get_collider()
	if target.is_in_group("characters"):
		game_state.make_accusation(target)

func show_interaction_prompt(text: String):
	interaction_text.text = text
	interaction_text.visible = true

func clear_interaction_target():
	if is_instance_valid(current_interactable):
		current_interactable.disable_highlight()
	current_interactable = null
	interaction_text.visible = false
