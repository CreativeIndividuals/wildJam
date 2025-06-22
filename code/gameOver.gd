extends Control

@onready var result_label = $result
@onready var result_details: Label = $"result details"
#@onready var quit_button = $Button

func _ready():
	hide()
	




func _on_game_state_game_over(correct: bool) -> void:
	result_label.text = "You Have " + ("Won" if correct else "Lost") + " The Game"
	result_details.text = "it was your "+%GameState.impostor_character.character_name +" all along"
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_button_pressed() -> void:
	get_tree().quit() # Replace with function body.
