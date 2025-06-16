extends CharacterBody3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

@onready var game_state = $"/root/GameState"
@onready var camera = $Camera3D
@onready var ray = $Camera3D/RayCast3D
@onready var dialogue_text = $UI/DialogueText

# Dialogue lines for genuine characters and impostor
const GENUINE_LINES = [
	"Remember our fishing trip to the lake...",
	"That baseball glove you always carried...",
	"The old family photos in the attic...",
]

const IMPOSTOR_LINES = [
	"I remember that sketchbook you had...",
	"Those cornflakes you'd eat every morning...",
	"The board games we used to play...",
]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ray.target_position = Vector3(0, 0, -2)

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
		
	var collider = ray.get_collider()
	
	match game_state.current_phase:
		game_state.Phase.RESEARCH:
			if collider.is_in_group("clues"):
				collider.queue_free() # Simple collect mechanic
		
		game_state.Phase.JUDGEMENT:
			if collider.is_in_group("characters"):
				play_dialogue(collider.get_index())

func handle_accuse():
	if game_state.current_phase != game_state.Phase.JUDGEMENT:
		return
		
	if ray.is_colliding() and ray.get_collider().is_in_group("characters"):
		game_state.make_accusation(ray.get_collider().get_index())

func play_dialogue(char_index: int):
	# Select dialogue based on whether character is impostor
	var line = IMPOSTOR_LINES.pick_random() if char_index == game_state.impostor_index else GENUINE_LINES.pick_random()
	
	dialogue_text.text = line
	dialogue_text.visible = true
	
	# Hide dialogue after delay
	await get_tree().create_timer(game_state.DIALOGUE_DURATION).timeout
	dialogue_text.visible = false

func _physics_process(_delta):
	if game_state.current_phase in [game_state.Phase.WIN, game_state.Phase.LOSS]:
		return # Stop movement after game end
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
