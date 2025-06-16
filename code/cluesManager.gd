extends Node

signal clue_collected(clue_data)
signal all_clues_collected

var collected_clues = {}
var total_clues: int
var clues_found: int = 0

func _ready():
	# Count total clues in scene
	total_clues = get_tree().get_nodes_in_group("interactables").size()
	
	# Connect to all interactables
	for interactable in get_tree().get_nodes_in_group("interactables"):
		interactable.clue_inspected.connect(_on_clue_inspected)

func _on_clue_inspected(clue_data: Dictionary):
	collected_clues[clue_data.id] = clue_data
	clues_found += 1
	clue_collected.emit(clue_data)
	
	if clues_found >= total_clues:
		all_clues_collected.emit()

func get_clue(clue_id: String) -> Dictionary:
	return collected_clues.get(clue_id, {})

func has_clue(clue_id: String) -> bool:
	return collected_clues.has(clue_id)

func get_all_clues() -> Dictionary:
	return collected_clues

func clear_clues():
	collected_clues.clear()
	clues_found = 0
