extends ColorRect

func _ready():
	color = Color(0, 0, 0, 0)

func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "color:a", 1.0, 1.0)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "color:a", 0.0, 1.0)
