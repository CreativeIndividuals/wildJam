extends Node

enum Phase {RESEARCH, JUDGEMENT}

signal game_over(correct: bool)

var current_phase: Phase = Phase.RESEARCH
@export var impostor_character :Character

func _ready():
	current_phase = Phase.RESEARCH
	%audioManager.play_ost()
	$Timer.start()

func transition_to_judgement():
	%blackoutOverlay.play_blackout()
	current_phase = Phase.JUDGEMENT

func make_accusation(character):
	game_over.emit(character==impostor_character)
