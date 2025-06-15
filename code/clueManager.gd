extends Node

signal clue_collected(clue_id, owner)

var collected_clues = {}
var clue_owners = {
	# Mother's clues
	"sketchbook": "Mother",
	"cornflakes": "Mother",
	# Father's clues
	"newspaper": "Father",
	"coffee_mug": "Father",
	# Brother's clues
	"boardgame": "Brother",
	"tv_console": "Brother",
	# Girlfriend's clues
	"cassette": "Girlfriend",
	"easel": "Girlfriend"
}

func collect_clue(clue_id: String):
	if clue_id in clue_owners:
		collected_clues[clue_id] = clue_owners[clue_id]
		clue_collected.emit(clue_id, clue_owners[clue_id])

func has_clue(clue_id: String) -> bool:
	return clue_id in collected_clues

func get_clue_owner(clue_id: String) -> String:
	return collected_clues.get(clue_id, "")

func get_character_clues(character: String) -> Array:
	var character_clues = []
	for clue_id in collected_clues:
		if collected_clues[clue_id] == character:
			character_clues.append(clue_id)
	return character_clues

func reset():
	collected_clues.clear()
