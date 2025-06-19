class_name Character
extends RigidBody3D

signal dialogue_triggered(name, line)

@export var character_name: String
@export_multiline var dialogue_lines: Array[String] = []

func _ready():
	add_to_group("characters")

func listen():
	var line = dialogue_lines[randi() % dialogue_lines.size()] if dialogue_lines.size() > 0 else "..."
	emit_signal("dialogue_triggered", character_name, line)
