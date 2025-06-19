extends Node

enum Phase {
	RESEARCH,
	DIALOGUE,
	JUDGEMENT,
	WIN,
	LOSE
}

signal phase_changed(new_phase: Phase)
signal game_over(correct: bool)

@export var current_phase: Phase = Phase.RESEARCH
@export var impostor_character: Character

func _ready() -> void:
	setup_game()

func setup_game() -> void:
	current_phase = Phase.RESEARCH
	emit_signal("phase_changed", current_phase)

	# Pick your impostor; adjust node path as needed:
	impostor_character = get_node("/root/Main/DialogueRoom/Girlfriend")

	# Start the research music
	#AudioManager.play_bgm(preload("res://audio/research_loop.ogg"))

func transition_to_dialogue() -> void:
	current_phase = Phase.DIALOGUE
	emit_signal("phase_changed", current_phase)

	BlackoutManager.fade_out(1.0)
	await get_tree().create_timer(1.2).timeout
	BlackoutManager.fade_in(1.0)

	AudioManager.stop_bgm()
	#AudioManager.play_sfx(preload("res://audio/door_creak.ogg"))
	#AudioManager.play_bgm(preload("res://audio/dialogue_loop.ogg"))

func transition_to_judgement() -> void:
	current_phase = Phase.JUDGEMENT
	emit_signal("phase_changed", current_phase)

	BlackoutManager.fade_out(0.8)
	await get_tree().create_timer(1.0).timeout
	BlackoutManager.fade_in(0.8)

	AudioManager.stop_bgm()
	#AudioManager.play_bgm(preload("res://audio/judgement_theme.ogg"))

func make_accusation(character: Character) -> void:
	var correct = (character == impostor_character)
	emit_signal("game_over", correct)

	#if correct:
		#AudioManager.play_sfx(preload("res://audio/victory.ogg"))
	#else:
		#AudioManager.play_sfx(preload("res://audio/defeat.ogg"))
