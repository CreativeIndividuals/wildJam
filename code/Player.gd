extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENSITIVITY = 0.002
const RAY_LENGTH = 2.0

@onready var camera = $Camera3D
@onready var ray_cast = $Camera3D/RayCast3D
@onready var interaction_prompt = $InteractionPrompt

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_move = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ray_cast.target_position = Vector3(0, 0, -RAY_LENGTH)

func _unhandled_input(event):
	if event is InputEventMouseMotion and can_move:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("interact") and can_move:
		try_interact()

func _physics_process(delta):
	if not can_move:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	update_interaction_prompt()

func try_interact():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("interactables"):
			collider.interact()

func update_interaction_prompt():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("interactables"):
			interaction_prompt.show()
			return
	interaction_prompt.hide()

func set_movement_enabled(enabled: bool):
	can_move = enabled
