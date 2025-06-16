extends Node

signal clue_discovered(clue_id, owner)

var discovered_clues = {}  # Dictionary of clue_id: owner pairs

func _ready():
	# Connect to all interactables in the scene
	get_tree().call_group("interactables", "connect", "clue_inspected", _on_clue_inspected)

func _on_clue_inspected(clue_id: String, owner: String):
	discovered_clues[clue_id] = owner
	clue_discovered.emit(clue_id, owner)

func has_clue(clue_id: String) -> bool:
	return discovered_clues.has(clue_id)

func get_clue_owner(clue_id: String) -> String:
	return discovered_clues.get(clue_id, "")

func validate_memory(character: String, clue_id: String) -> bool:
	if not has_clue(clue_id):
		return false
	return discovered_clues[clue_id] == character

func clear_clues():
	discovered_clues.clear()
