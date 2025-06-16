extends Control

@onready var result_label = $ResultLabel
@onready var retry_button = $RetryButton
@onready var quit_button = $QuitButton

func _ready():
	hide()
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	%GameState.game_over.connect(_on_game_over)

func _on_game_over(correct: bool):
	result_label.text = "You " + ("Found" if correct else "Missed") + " the Impostor!"
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry_pressed():
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func _on_quit_pressed():
	get_tree().quit()
