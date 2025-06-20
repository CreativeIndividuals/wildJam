class_name Interractable
extends RigidBody3D

@export var clueID:String
@export_multiline var description: String

var highlight_material: StandardMaterial3D

signal clueInspected(clueData:Dictionary)

func _ready():
	add_to_group("clues")
	_setup_highlight_material()

func _setup_highlight_material():
	highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color = Color(1.0, 0.85, 0.0, 0.6)
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1.0, 0.85, 0.0, 1.0)
	highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	if has_node("MeshInstance3D"):
		$MeshInstance3D.material_overlay = null

func interact():
	clueInspected.emit({"id":clueID,"description":description})
	%audioManager.play_sfx("interact")

func enable_highlight():
	$MeshInstance3D.material_overlay = highlight_material

func disable_highlight():
	$MeshInstance3D.material_overlay = null
