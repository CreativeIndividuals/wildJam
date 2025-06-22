class_name Character
extends RigidBody3D

@export var character_name: String
@export_multiline var dialogue_lines: Array[String] = []

signal spoke(char,text)

var dialogue_manager: Node

func _ready():
	add_to_group("characters")
	dialogue_manager = %dialogueBox

func listen():
	spoke.emit(character_name, dialogue_lines[randi() % dialogue_lines.size()])
