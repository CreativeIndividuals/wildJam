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
@onready var phase_text = $Player/UI/PhaseText
@onready var timer_text = $Player/UI/TimerText

const JUDGEMENT_POSITION = Vector3(0, 0, 5)
const DIALOGUE_DURATION = 3.0

func _ready():
	impostor_index = randi() % 4
	timer.wait_time = research_time
	timer.one_shot = true
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	
	for character in characters.get_children():
		character.visible = false
	dialogue_text.visible = false
	end_text.visible = false
	phase_text.text = "RESEARCH PHASE: Find the clues!"
	
	print("Debug - Impostor is: ", impostor_index)

func _process(_delta):
	if current_phase == Phase.RESEARCH:
		timer_text.text = "Time: %d" % timer.time_left
	
func _on_Timer_timeout():
	current_phase = Phase.JUDGEMENT
	timer_text.visible = false
	phase_text.text = "JUDGEMENT PHASE\nE to Listen - Q to Accuse"
	
	player.global_position = JUDGEMENT_POSITION
	player.rotation.y = PI
	
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
	phase_text.visible = false
