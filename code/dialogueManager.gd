# res://scripts/DialogueManager.gd
extends Node

@onready var person       := $VBoxContainer/Person
@onready var dialogueLine := $VBoxContainer/Line
@onready var timer        := $VBoxContainer/Timer

@export var DialogueTimeout := 5.0
@export var pop_sfx: AudioStream

func _ready():
	# Start hidden
	$VBoxContainer.hide()

	# Connect all characters' dialogue_triggered signals
	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("dialogue_triggered", Callable(self, "_on_character_spoke"))

	# Connect clue collection (if you want the manager to respond to clues)
	for clue in get_tree().get_nodes_in_group("clues"):
		clue.connect("clueInspected", Callable(self, "_on_clue_collected"))

	# Connect the GameState phase_changed if you want to show a prompt
	GameState.connect("phase_changed", Callable(self, "_on_game_state_phase_changed"))

	# Connect our timer
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))


func _on_character_spoke(name: String, line: String) -> void:
	show_dialogue(name, line)


func show_dialogue(character_name: String, line: String) -> void:
	person.text       = character_name
	dialogueLine.text = line
	$VBoxContainer.show()
	timer.start(DialogueTimeout)
	AudioManager.play_sfx(pop_sfx)


func _on_Timer_timeout() -> void:
	$VBoxContainer.hide()


func _on_game_state_phase_changed(new_phase: int) -> void:
	# Example prompt when entering a new phase:
	show_dialogue(
		"Narrator",
		"What happened? Where am I? \nI only remember three of you… WHICH ONE IS FAKE?"
	)


func _on_clue_collected(clue_data: Dictionary) -> void:
	# Shows a little self‑narration whenever you pick up a clue:
	var id   = clue_data.get("id", "<unknown>")
	var desc = clue_data.get("description", "")
	show_dialogue("Me", "Hmm… a %s: %s" % [id, desc])
