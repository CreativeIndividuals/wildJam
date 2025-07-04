extends Control
@onready var optionsMenu = preload("res://scenes/Menu.tscn")
func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()


func _on_quit_pressed():
	get_tree().quit()
	
func _on_resume_pressed() -> void:
	resume()# Replace with function body.

func _on_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file('res://scenes/Menu.tscn')# Replace with function body.


func _process(delta):
	testEsc()



	
