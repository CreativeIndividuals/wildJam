class_name Character
extends RigidBody3D

signal dialogue_triggered(character_name: String, line: String)

@export var character_name: String
@export var dialogue_lines: Array[String] = []

var is_impostor: bool = false

func _ready():
	add_to_group("characters")

func listen():
	if dialogue_lines.is_empty():
		return
	
	# Pick a random line
	var line = dialogue_lines[randi() % dialogue_lines.size()]
	dialogue_triggered.emit(character_name, line)

func set_as_impostor():
	is_impostor = true

func is_the_impostor() -> bool:
	return is_impostor
