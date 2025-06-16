extends Node

enum Phase {RESEARCH, JUDGEMENT, WIN, LOSS}

var current_phase = Phase.RESEARCH
var impostor_index: int
var research_time: float = 120.0 # 2 minutes

@onready var timer = $Timer
@onready var player = $Player
@onready var ui = $Player/UI
@onready var characters = $Characters
@onready var dialogue_text = $Player/UI/DialogueText
@onready var end_text = $Player/UI/EndText

const JUDGEMENT_POSITION = Vector3(0, 0, 5)
const DIALOGUE_DURATION = 3.0

func _ready():
	# Initialize game state
	impostor_index = randi() % 4
	timer.wait_time = research_time
	timer.one_shot = true
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	
	# Hide characters and UI elements initially
	for character in characters.get_children():
		character.visible = false
	dialogue_text.visible = false
	end_text.visible = false
	
	print("Debug - Impostor is: ", impostor_index) # Debug info

func _on_Timer_timeout():
	current_phase = Phase.JUDGEMENT
	
	# Move player to judgement room
	player.global_position = JUDGEMENT_POSITION
	player.rotation.y = PI
	
	# Show characters
	for character in characters.get_children():
		character.visible = true

func make_accusation(index: int):
	if index == impostor_index:
		current_phase = Phase.WIN
		end_text.text = "You Win! You caught the impostor!"
	else:
		current_phase = Phase.LOSS
		end_text.text = "Wrong! The real impostor was Character " + str(impostor_index)
	end_text.visible = true
