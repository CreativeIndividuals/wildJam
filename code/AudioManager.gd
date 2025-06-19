extends Node

@export_multiline var effects :Dictionary[String,String] = {"blackout":"test"}

var ost_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	ost_player=$ost
	sfx_player=$sfx

func play_ost():
	ost_player.play()

func stop_ost():
	ost_player.stop()

func play_sfx(effect:String):
	sfx_player.stream.resource_path = effects[effect]
	sfx_player.play()
