extends Control

func show_result(won: bool):
	show()
	$ResultLabel.text = "You Win!" if won else "You Lost!"

func _on_restart_button_pressed():
	get_node("/root/GameState").start_game()
	hide()
