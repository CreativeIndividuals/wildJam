class_name Interractable
extends Area3D

signal clue_inspected(clue_data: Dictionary)

@export var clue_id: String
@export var memory_owner: String
@export var description: String

var highlight_material: StandardMaterial3D

func _ready():
	add_to_group("interactables")
	_setup_highlight_material()
	
	# Auto-connect to DialogueBox
	var dialogue_box = %dialogueBox
	if dialogue_box:
		# Connect the signal to the dialogue box
		if !clue_inspected.is_connected(dialogue_box._on_clue_inspected):
			clue_inspected.connect(dialogue_box._on_clue_inspected)
	else:
		push_error("DialogueBox not found for clue: " + clue_id)

func _setup_highlight_material():
	highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color = Color(1.0, 0.85, 0.0, 0.6)
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1.0, 0.85, 0.0, 1.0)
	
	if has_node("Mesh"):
		$Mesh.material_overlay = null

func interact():
	clue_inspected.emit({
		"id": clue_id,
		"owner": memory_owner,
		"description": description
	})
	queue_free()

func enable_highlight():
	if has_node("Mesh"):
		$Mesh.material_overlay = highlight_material

func disable_highlight():
	if has_node("Mesh"):
		$Mesh.material_overlay = null
