extends Area3D

@export var clue_id: String
@export var memory_owner: String
@export_multiline var description: String
@export var is_key_evidence: bool = false

var highlight_material: StandardMaterial3D
var dialogue_manager: Node
var game_state: Node
var has_been_inspected = false

func _ready():
	add_to_group("interactables")
	_setup_highlight_material()
	
	# Get references
	dialogue_manager = %dialogueBox
	game_state =%GameState
	
	if !dialogue_manager:
		push_error("DialogueManager not found for clue: " + clue_id)

func _setup_highlight_material():
	highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color = Color(1.0, 0.85, 0.0, 0.6)
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1.0, 0.85, 0.0, 1.0)
	highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	if has_node("MeshInstance3D"):
		$MeshInstance3D.material_overlay = null

func interact():
	if has_been_inspected or !dialogue_manager:
		return
		
	if game_state.current_phase != game_state.Phase.RESEARCH:
		dialogue_manager.start_dialogue("Me", "I should focus on finding the impostor now.")
		return
		
	has_been_inspected = true
	dialogue_manager.start_dialogue("Me", "Found something: " + description)
	
	if is_key_evidence:
		game_state.evidence_found()
	
	# Optional: Make the clue disappear after inspection
	# queue_free()

func enable_highlight():
	if has_node("MeshInstance3D") and !has_been_inspected:
		$MeshInstance3D.material_overlay = highlight_material

func disable_highlight():
	if has_node("MeshInstance3D"):
		$MeshInstance3D.material_overlay = null
