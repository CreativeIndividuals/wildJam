extends StaticBody3D

@export var clue_id: String
@export_multiline var description: String

signal interacted(clue_id)

func _ready():
	add_to_group("interactables")

func interact():
	interacted.emit(clue_id)
	
func enable():
	collision_layer = 1
	collision_mask = 1
	
func disable():
	collision_layer = 0
	collision_mask = 0
