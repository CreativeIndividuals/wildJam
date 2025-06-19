extends TextureRect

@onready var dialogueLine: Label = $Line
@onready var person: Label = $Person
@onready var timer = $Timer

@export var DialogueTimeout := 5.0

func _ready():
	hide()
	for clue in get_tree().get_nodes_in_group("clues"):
		clue.clueInspected.connect(_on_clue_collected)
	for character in get_tree().get_nodes_in_group("characters"):
		character.dialogue_triggered.connect(show_dialogue)

func show_dialogue(character_name: String, line: String):
	person.text=character_name
	dialogueLine.text = line
	show()
	timer.start(DialogueTimeout)

func _on_timer_timeout():
	hide()

func _on_blackout_done() -> void:
	show_dialogue("Me","what happened? \nwhere am i? \nanyways I only remember three of you being there WHICH ONE IS FAKE")

func _on_clue_collected(clue_data: Dictionary)->void:
	show_dialogue("Me","hmm... a "+clue_data.get("id")+" "+clue_data.get("description"))
