extends Control

@onready var result_label   := $Result
@onready var result_details := $Details
@onready var quit_button    := $Button

func _ready():
	hide()
	quit_button.pressed.connect(Callable(self, "_on_quit_pressed"))
	GameState.connect("game_over", Callable(self, "_on_game_over"))

func _on_quit_pressed():
	get_tree().quit()

func _on_game_over(won: bool) -> void:
	# Use GDScript’s `if … else` expression instead of `?:`
	result_label.text = "You " + ("Won!" if won else "Lost.")
	result_details.text = "It was %s all along." % GameState.impostor_character.character_name
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
