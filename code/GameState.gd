extends Node

signal phase_changed(new_phase)
signal time_updated(seconds_left)

enum GamePhase {INIT, RESEARCH, BLACKOUT, JUDGEMENT, WIN, LOSS}

const RESEARCH_TIME = 120.0  # 2 minutes
const BLACKOUT_DURATION = 2.0

var current_phase: GamePhase = GamePhase.INIT
var family_members = ["Mother", "Father", "Brother", "Girlfriend"]
var impostor_index: int = -1
var creature_identity: String = ""

@onready var timer = $Timer #for researching
@onready var blackout_timer = $BlackoutTimer

func _ready():
	setup_timers()
	start_game()

func setup_timers():
	timer.wait_time = RESEARCH_TIME
	timer.one_shot = true
	timer.timeout.connect(_on_research_timer_timeout)
	
	blackout_timer.wait_time = BLACKOUT_DURATION
	blackout_timer.one_shot = true
	blackout_timer.timeout.connect(_on_blackout_timer_timeout)

func start_game():
	# Pick random impostor
	impostor_index = randi() % family_members.size()
	creature_identity = family_members[impostor_index]
	change_phase(GamePhase.RESEARCH)
	timer.start()

func change_phase(new_phase: GamePhase):
	current_phase = new_phase
	phase_changed.emit(new_phase)
	
	match new_phase:
		GamePhase.RESEARCH:
			get_tree().call_group("interactables", "enable")
			$Player.set_movement_enabled(true)
		GamePhase.BLACKOUT:
			get_tree().call_group("interactables", "disable")
			$Player.set_movement_enabled(false)
			$UI/BlackoutOverlay.fade_in()
			blackout_timer.start()
		GamePhase.JUDGEMENT:
			$UI/BlackoutOverlay.fade_out()
			$UI/DialogueUI.start_dialogue()
		GamePhase.WIN, GamePhase.LOSS:
			$UI/GameOverUI.show_result(new_phase == GamePhase.WIN)

func _on_research_timer_timeout():
	change_phase(GamePhase.BLACKOUT)

func _on_blackout_timer_timeout():
	change_phase(GamePhase.JUDGEMENT)

func make_accusation(accused_index: int):
	if accused_index == impostor_index:
		change_phase(GamePhase.WIN)
	else:
		change_phase(GamePhase.LOSS)
