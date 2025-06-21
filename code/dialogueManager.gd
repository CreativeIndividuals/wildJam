extends TextureRect

@onready var dialogueLine: Label = $Line
@onready var person: Label = $Person
@onready var timer = $Timer

@export var DialogueTimeout := 5.0
var speaking:=false

func _ready():
	hide()
	for clue in get_tree().get_nodes_in_group("clues"):
		clue.clueInspected.connect(_on_clue_collected)
	for character in get_tree().get_nodes_in_group("characters"):
		character.spoke.connect(show_dialogue)

func show_dialogue(character_name: String, line: String) -> void:
	if speaking:
		return
	person.text = character_name
	show()
	timer.stop()
	speaking=true
	dialogueLine.text = ""
	for i in line.length() + 1:
		dialogueLine.text = line.substr(0, i) + "_"
		await get_tree().create_timer(0.05).timeout
	dialogueLine.text = line
	timer.start(DialogueTimeout)

func _on_timer_timeout():
	speaking=false
	hide()

func _on_blackout_done() -> void:
	show_dialogue("Me","what happened? nwhere am i? \nanyways I only remember three of you being there \nWHICH ONE IS FAKE?")

func _on_clue_collected(clue_data: Dictionary)->void:
	%audioManager.play_sfx("flip page")
	show_dialogue(clue_data.get("id"),clue_data.get("description"))
