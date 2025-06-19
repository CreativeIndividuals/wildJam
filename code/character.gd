class_name Character
extends RigidBody3D

@export var character_name: String
@export_multiline var dialogue_lines: Array[String] = []

var dialogue_manager: Node

func _ready():
	add_to_group("characters")
	# Get references
	dialogue_manager = %dialogueBox

func listen():
	if dialogue_lines.is_empty():
		dialogue_manager.show_dialogue(character_name, "...")
		return
	dialogue_manager.show_dialogue(character_name, dialogue_lines[randi() % dialogue_lines.size()])
