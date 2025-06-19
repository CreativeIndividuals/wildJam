extends CharacterBody3D

const SPEED      := 5.0
const MOUSE_SENS := 0.002

@onready var camera           := $Camera3D
@onready var ray              := $Camera3D/interactRange
@onready var interaction_text := get_node("/root/Main/UI/HUD/Interact")
@onready var game_state       := get_node("/root/GameState")

var current_interactable: Interractable = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_text.visible = false

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

	# Interaction / Accusation
	if event.is_action_pressed("interact"):
		_handle_interaction()
	elif event.is_action_pressed("accuse"):
		_handle_accusation()

	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	_move_player()
	_update_hover()

func _move_player():
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var forward   = -camera.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = camera.global_transform.basis.x
	right.y = 0
	right = right.normalized()

	var dir = forward * input_dir.y + right * input_dir.x

	if dir != Vector3.ZERO:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _update_hover():
	if not ray.is_colliding():
		_clear_interaction_target()
		return

	var parent = ray.get_collider().get_parent()
	if parent is Interractable and game_state.current_phase == game_state.Phase.RESEARCH:
		if current_interactable != parent:
			if current_interactable:
				current_interactable.disable_highlight()
			current_interactable = parent
			current_interactable.enable_highlight()
		_show_prompt("Press [E] to inspect")
	elif parent.is_in_group("characters") and game_state.current_phase == game_state.Phase.JUDGEMENT:
		_show_prompt("E: Listen  Q: Accuse")
	else:
		_clear_interaction_target()

func _handle_interaction():
	if not ray.is_colliding():
		return
	var parent = ray.get_collider().get_parent()
	if game_state.current_phase == game_state.Phase.RESEARCH and parent is Interractable:
		parent.interact()
	elif game_state.current_phase == game_state.Phase.JUDGEMENT and parent.is_in_group("characters"):
		parent.listen()

func _handle_accusation():
	if game_state.current_phase != game_state.Phase.JUDGEMENT:
		return
	if not ray.is_colliding():
		return
	var parent = ray.get_collider().get_parent()
	if parent.is_in_group("characters"):
		game_state.make_accusation(parent)

func _show_prompt(text: String):
	interaction_text.text    = text
	interaction_text.visible = true

func _clear_interaction_target():
	if current_interactable:
		current_interactable.disable_highlight()
	current_interactable = null
	interaction_text.visible = false
