extends StaticBody3D
class_name Interractable

signal clue_inspected(clue_id, owner,description)

@export var clue_id: String
@export var memory_owner: String
@export var description: String

var material: StandardMaterial3D

func _ready():
	add_to_group("interactables")
	setup_highlight_material()

func setup_highlight_material():
	# Create highlight material for visual feedback
	material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.85, 0.0, 0.6)
	material.emission_enabled = true
	material.emission = Color(1.0, 0.85, 0.0, 1.0)
	
	# Assuming the interactable has a MeshInstance3D child
	if has_node("Mesh"):
		$Mesh.material_overlay = material
		disable_highlight()

func interact():
	clue_inspected.emit(clue_id, memory_owner,description)
	
	#TODO Visual/Audio feedback
	queue_free()

func enable_highlight():
	if has_node("Mesh"):
		$Mesh.material_overlay = material

func disable_highlight():
	if has_node("Mesh"):
		$Mesh.material_overlay = null
