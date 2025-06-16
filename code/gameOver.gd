extends Control

@onready var result_label = $result
@onready var result_details: Label = $"result details"
@onready var quit_button = $Button

func _ready():
	hide()
	quit_button.pressed.connect(_on_quit_pressed)

func _on_retry_pressed():
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_quit_pressed():
	get_tree().quit()


func _on_game_state_game_over(correct: bool) -> void:
	result_label.text = "You " + ("Found" if correct else "Missed") + " the Impostor!"
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
