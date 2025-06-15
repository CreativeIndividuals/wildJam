extends Node

@onready var ambient_player: AudioStreamPlayer = $AmbientPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer

const SOUNDS = {
	#"ambient": preload("res://audio/ambient.ogg"),
	#"blackout": preload("res://audio/blackout.ogg"),
	#"judgement": preload("res://audio/judgement.ogg"),
	#"heartbeat": preload("res://audio/heartbeat.ogg"),
	#"win": preload("res://audio/win.ogg"),
	#"lose": preload("res://audio/lose.ogg"),
	#"collect": preload("res://audio/collect.ogg")
}

func play_ambient():
	_crossfade_to(ambient_player, SOUNDS.ambient)

func play_blackout():
	sfx_player.stream = SOUNDS.blackout
	sfx_player.play()

func play_judgement():
	_crossfade_to(music_player, SOUNDS.judgement)

func play_heartbeat():
	sfx_player.stream = SOUNDS.heartbeat
	sfx_player.play()

func _crossfade_to(player: AudioStreamPlayer, stream: AudioStream):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, 1.0)
	await tween.finished
	player.stream = stream
	player.play()
	tween = create_tween()
	tween.tween_property(player, "volume_db", 0.0, 1.0)
