extends CanvasLayer

@onready var fade_rect := $ColorRect

func _ready():
	fade_rect.color.a = 0
	hide()

func fade_out(duration := 1.0):
	show()
	var tw = create_tween()
	tw.tween_property(fade_rect, "color:a", 1.0, duration)

func fade_in(duration := 1.0):
	var tw = create_tween()
	tw.tween_property(fade_rect, "color:a", 0.0, duration).connect(
		"finished", Callable(self, "_on_fade_in_complete")
	)

func _on_fade_in_complete():
	hide()
