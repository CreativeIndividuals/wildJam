class_name Interractable
extends RigidBody3D

@export var clue_id: String
@export_multiline var description: String

var highlight_material: StandardMaterial3D
signal clueInspected(clueData: Dictionary)

func _ready():
	add_to_group("clues")
	_setup_highlight_material()

func _setup_highlight_material():
	highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color   = Color(1,0.85,0,0.6)
	highlight_material.emission_enabled = true
	highlight_material.emission        = Color(1,0.85,0,1)
	highlight_material.transparency    = BaseMaterial3D.TRANSPARENCY_ALPHA

func interact():
	clueInspected.emit({"id": clue_id, "description": description})

func enable_highlight():
	if has_node("MeshInstance3D"):
		$MeshInstance3D.material_overlay = highlight_material

func disable_highlight():
	if has_node("MeshInstance3D"):
		$MeshInstance3D.material_overlay = null
