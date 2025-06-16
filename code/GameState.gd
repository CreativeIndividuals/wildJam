extends Node

enum Phase {RESEARCH, JUDGEMENT}

signal phase_changed(new_phase: Phase)
signal game_over(correct: bool)

var current_phase: Phase = Phase.RESEARCH
var impostor_character = null

func _ready():
	setup_game()

func setup_game():
	current_phase = Phase.RESEARCH
	_assign_impostor()

func transition_to_judgement():
	current_phase = Phase.JUDGEMENT
	phase_changed.emit(current_phase)

func make_accusation(character):
	if current_phase != Phase.JUDGEMENT:
		return
	
	if character.has_method("is_the_impostor"):
		game_over.emit(character.is_the_impostor())
		
func _assign_impostor():
	var characters = get_tree().get_nodes_in_group("characters")
	if characters.is_empty():
		return
	
	impostor_character = characters[randi() % characters.size()]
	if impostor_character.has_method("set_as_impostor"):
		impostor_character.set_as_impostor()
