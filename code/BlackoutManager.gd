extends ColorRect

@export var duration:=5.0
signal blackoutDone

func _ready():
	color.a = 1
	create_tween().tween_property($".", "color:a", 0.0, duration).connect(
		"finished", Callable(self, "hide")
	)

func fade_out(): 
	create_tween().tween_property($".", "color:a", 0.0, duration).connect(
		"finished", Callable(self, "_on_fade_out_complete")
	)

func play_blackout():
	show()
	%audioManager.play_sfx("blackout")
	create_tween().tween_property($".", "color:a", 1.0, duration/2.0).connect(
		"finished", Callable(self, "_on_fade_in_complete")
	)

func _on_fade_in_complete():
	fade_out()

func _on_fade_out_complete():
	emit_signal("blackoutDone")
	hide()
