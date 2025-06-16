extends Control

var current_speaker_index = 0
var memories = {
	"Mother": ["family_photo", "old_diary"],
	"Father": ["workbench", "fishing_rod"],
	"Brother": ["game_console", "sports_trophy"],
	"Girlfriend": ["mix_tape", "art_supplies"]
}

@onready var speaker_label = $SpeakerLabel
@onready var dialogue_label = $DialogueLabel
@onready var portraits = $Portraits
@onready var next_button = $NextButton

func start_dialogue():
	show()
	current_speaker_index = 0
	show_next_statement()

func show_next_statement():
	if current_speaker_index >= 4:
		show_accusation_prompt()
		return
		
	var game_state = get_node("/root/GameState")
	var current_character = game_state.family_members[current_speaker_index]
	speaker_label.text = current_character
	
	var statement
	if current_speaker_index == game_state.impostor_index:
		# Creature lies by using a memory from another character
		var valid_memories = []
		for character in memories:
			if character != current_character:
				valid_memories.append_array(memories[character])
		var fake_memory = valid_memories[randi() % valid_memories.size()]
		statement = generate_statement(fake_memory)
	else:
		var char_memories = memories[current_character]
		var true_memory = char_memories[randi() % char_memories.size()]
		statement = generate_statement(true_memory)
	
	dialogue_label.text = statement
	current_speaker_index += 1

func generate_statement(memory: String) -> String:
	var statements = [
		"I remember when we used the %s together.",
		"Don't you remember the %s we shared?",
		"We spent so much time with the %s.",
		"The %s was special to us."
	]
	return statements[randi() % statements.size()] % memory

func show_accusation_prompt():
	dialogue_label.text = "One of us is not who they seem. Who is the impostor?"
	next_button.hide()
	# Enable portrait clicking for accusation

func _on_portrait_clicked(index: int):
	if not next_button.visible:  # In accusation phase
		get_node("/root/GameState").make_accusation(index)

func _on_next_button_pressed():
	show_next_statement()
