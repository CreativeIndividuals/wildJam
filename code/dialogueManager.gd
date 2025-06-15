extends Control

signal dialogue_finished

var current_speaker_index = 0
var dialogue_active = false

@onready var speaker_label = $SpeakerLabel
@onready var dialogue_label = $DialogueLabel
@onready var next_button = $NextButton
@onready var accuse_button = $AccuseButton

var character_statements = {
	"Mother": ["I remember drawing in your sketchbook.", "We always had cornflakes for breakfast."],
	"Father": ["I read the newspaper to you every Sunday.", "Remember our morning coffee talks?"],
	"Brother": ["Remember that board game we used to play?", "We spent hours on that old TV console."],
	"Girlfriend": ["That cassette player was our favorite.", "I taught you how to paint at that easel."]
}

var creature_lies = {
	"Mother": ["Remember our morning coffee talks?", "We spent hours on that TV console."],
	"Father": ["We always had cornflakes for breakfast.", "That cassette player was our favorite."],
	"Brother": ["I read the newspaper every Sunday.", "I taught you how to paint at that easel."],
	"Girlfriend": ["I remember drawing in your sketchbook.", "Remember that board game we used to play?"]
}

func start_dialogue():
	show()
	dialogue_active = true
	current_speaker_index = 0
	next_button.show()
	accuse_button.hide()
	show_next_statement()

func show_next_statement():
	if current_speaker_index >= 4:
		end_dialogue()
		return
		
	var game_state = get_node("/root/GameState")
	var current_character = game_state.family_members[current_speaker_index]
	speaker_label.text = current_character
	
	var statement
	if current_speaker_index == game_state.impostor_index:
		var lies = creature_lies[game_state.creature_identity]
		statement = lies[randi() % lies.size()]
	else:
		var truths = character_statements[current_character]
		statement = truths[randi() % truths.size()]
	
	dialogue_label.text = statement
	current_speaker_index += 1

func end_dialogue():
	next_button.hide()
	accuse_button.show()
	dialogue_label.text = "Who is the creature? Click on their portrait to accuse."

func _on_next_button_pressed():
	show_next_statement()

func _on_portrait_clicked(index: int):
	if accuse_button.visible:
		get_node("/root/GameState").make_accusation(index)
