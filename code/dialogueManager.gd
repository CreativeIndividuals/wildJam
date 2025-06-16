extends Node

signal dialogue_finished
signal character_speaking(character_name)

const DIALOGUE_DATA = {
	"Mother": {
		"clues": ["sketchbook", "cornflakes"],
		"lines": [
			"I remember the sketchbook you always carried...",
			"And those cornflakes you'd eat every morning..."
		]
	},
	"Brother": {
		"clues": ["boardgame", "tv_console"],
		"lines": [
			"Remember that board game we used to play?",
			"And the TV console we fought over..."
		]
	},
	"Girlfriend": {
		"clues": ["cassette", "easel"],
		"lines": [
			"That old cassette player still has our song...",
			"The easel where you painted our first date..."
		]
	},
	"Creature": {
		"clues": ["fishing_trip", "baseball_glove"],
		"lines": [
			"The fishing trip photo from last summer...",
			"Your lucky baseball glove from childhood..."
		]
	}
}

var current_speaker: String
var dialogue_index: int = 0
var characters: Array
var impostor_index: int

func start_dialogue(character_list: Array, _impostor_index: int):
	characters = character_list
	impostor_index = _impostor_index
	dialogue_index = 0
	advance_dialogue()

func advance_dialogue():
	if dialogue_index >= characters.size():
		dialogue_finished.emit()
		return
		
	current_speaker = characters[dialogue_index]
	character_speaking.emit(current_speaker)
	
	# If this is the impostor, use a random clue from another character
	if dialogue_index == impostor_index:
		var other_char = characters[(dialogue_index + 1) % characters.size()]
		var fake_clue = DIALOGUE_DATA[other_char]["clues"].pick_random()
		# Use the fake clue in dialogue
	
	dialogue_index += 1

func make_accusation(accused_index: int) -> bool:
	return accused_index == impostor_index
