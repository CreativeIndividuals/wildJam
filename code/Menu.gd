extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn") # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	

func _on_htp_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Howtoplay.tscn") 
 # Replace with function body.
	
func _ready() -> void:
	$ost.play()
