extends RigidBody3D

signal dialogue_triggered(character_name: String, line: String)

@export var character_name: String
@export var dialogue_lines: Array[String] = []
var is_impostor: bool = false

func _ready():
	add_to_group("characters")
	var dialogue_box =%dialogueBox
	if dialogue_box:
		# Connect the signal to the dialogue box
		if !dialogue_triggered.is_connected(dialogue_box._on_dialogue_triggered):
			dialogue_triggered.connect(dialogue_box._on_dialogue_triggered)
	else:
		push_error("DialogueBox not found for character: " + character_name)

func listen():
	if dialogue_lines.is_empty():
		return
	
	var line = dialogue_lines[randi() % dialogue_lines.size()]
	dialogue_triggered.emit(character_name, line)

func set_as_impostor():
	is_impostor = true

func is_the_impostor() -> bool:
	return is_impostor
