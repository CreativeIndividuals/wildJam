extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

@onready var game_state := %GameState
@onready var camera =$Camera3D
@onready var ray = $Camera3D/interactRange
@onready var interaction_text = %HUD/Interact

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_text.visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	elif event.is_action_pressed("interact"): # E key
		handle_interact()
	
	elif event.is_action_pressed("accuse"): # Q key
		handle_accuse()

func handle_interact():
	if not ray.is_colliding():
		return
		
	var collider:CollisionShape3D = ray.get_collider()
	
	match game_state.current_phase:
		game_state.Phase.RESEARCH:
			if collider.is_in_group("clues"):
				collider.get_parent().interact()
		
		game_state.Phase.JUDGEMENT:
			if collider.is_in_group("characters"):
				collider.get_parent().listen()

func handle_accuse():
	if game_state.current_phase != game_state.Phase.JUDGEMENT:
		return
		
	if ray.is_colliding() and ray.get_collider().is_in_group("characters"):
		game_state.make_accusation(ray.get_collider().get_parent().get_index())

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	# Update interaction prompts
	update_interaction_prompt()

func update_interaction_prompt():
	if not ray.is_colliding():
		interaction_text.visible = false
		return
		
	var collider = ray.get_collider()
	
	match game_state.current_phase:
		game_state.Phase.RESEARCH:
			if collider.is_in_group("clues"):
				interaction_text.text = "Press E to inspect"
				interaction_text.visible = true
			else:
				interaction_text.visible = false
		
		game_state.Phase.JUDGEMENT:
			if collider.is_in_group("characters"):
				interaction_text.text = "E: Listen\nQ: Accuse"
				interaction_text.visible = true
			else:
				interaction_text.visible = false
