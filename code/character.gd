extends RigidBody3D

signal dialogue_triggered(character_name: String, line: String)

@export var character_name: String
@export_multiline var dialogue_lines: Array[String] = []
@export_multiline var judgement_lines: Array[String] = []

var is_impostor: bool = false
var dialogue_manager: Node
var game_state: Node

func _ready():
	add_to_group("characters")
	
	# Get references
	dialogue_manager = %dialogueBox
	game_state = %GameState
	
	if !dialogue_manager:
		push_error("DialogueManager not found for character: " + character_name)

func listen():
	if !dialogue_manager:
		return
		
	var available_lines = []
	
	if game_state.current_phase == game_state.Phase.RESEARCH:
		available_lines = dialogue_lines
	else:  # JUDGEMENT phase
		available_lines = judgement_lines
	
	if available_lines.is_empty():
		dialogue_manager.start_dialogue(character_name, "...")
		return
	
	var line = available_lines[randi() % available_lines.size()]
	dialogue_manager.start_dialogue(character_name, line)

func set_as_impostor():
	is_impostor = true
	# Add some suspicious lines to their dialogue
	dialogue_lines.append("*looks nervous*")
	dialogue_lines.append("I... I don't know what you're talking about...")
	judgement_lines.append("You have no proof!")
	judgement_lines.append("This is ridiculous!")

func is_the_impostor() -> bool:
	return is_impostor
