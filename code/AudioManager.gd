extends Node

@export var bgm_volume := -10.0
@export var sfx_volume := 0.0

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music"
	bgm_player.volume_db = bgm_volume
	add_child(bgm_player)

	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	sfx_player.volume_db = sfx_volume
	add_child(sfx_player)

func play_bgm(stream: AudioStream, loop := true):
	bgm_player.stream = stream
	bgm_player.loop = loop
	bgm_player.play()

func stop_bgm():
	bgm_player.stop()

func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
