extends Node

@export var effects : Dictionary[String,String]

@onready var ost: AudioStreamPlayer = $ost
@onready var sfx: AudioStreamPlayer = $sfx
@onready var walk: AudioStreamPlayer = $walk

func _ready() -> void:
	for character in get_tree().get_nodes_in_group("characters"):
		character.spoke.connect(play_speech)

func play_speech(character,_dialogue):
	play_sfx("speech_"+character)

func play_ost():
	ost.play()

func stop_ost():
	ost.stop()

func play_sfx(effect: String):
	var path = effects.get(effect, "")
	if path == "":
		print("No such effect: ", effect)
		return
	var stream = load(path)
	if not stream:
		print("Failed to load SFX at: ", path)
		return
	sfx.stream = stream
	sfx.play()

func _on_player_walk_changed(walking: bool) -> void:
	if walking:
		walk.play()
	else:
		walk.stop()
