extends Node

@onready var dialogueLine: Label = $Line
@onready var person: Label = $Person
@onready var timer = $Timer
func _ready():
	$".".hide()
	timer.timeout.connect(_on_timer_timeout)
	
	# Connect to all characters in the scene
	for character in get_tree().get_nodes_in_group("characters"):
		character.dialogue_triggered.connect(show_dialogue)

func show_dialogue(character_name: String, line: String):
	dialogueLine.text = character_name + ": " + line
	$".".show()
	timer.start(3.0)  # Show dialogue for 3 seconds

func _on_timer_timeout():
	$".".hide()


func _on_game_state_phase_changed(new_phase: int) -> void:
	pass # Replace with function body.
