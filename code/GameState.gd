extends Node

enum Phase {RESEARCH, JUDGEMENT}

signal phase_changed(new_phase: Phase)
signal game_over(correct: bool)

@export var current_phase: Phase = Phase.RESEARCH
@export var impostor_character :Character

func _ready():
	setup_game()

func setup_game():
	current_phase = Phase.RESEARCH
	impostor_character= %girlfriend

func transition_to_judgement():
	#TODO blackout effect
	current_phase = Phase.JUDGEMENT
	phase_changed.emit(current_phase)

func make_accusation(character):
	game_over.emit(character==impostor_character)
