extends Control

var character_selections = {}

func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		toggle_character(1)
	if Input.is_action_just_pressed("move_up"):
		toggle_character(2)
	if Input.is_action_just_pressed("move_down"):
		toggle_character(3)
	if Input.is_action_just_pressed("move_right"):
		toggle_character(4)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept") and character_selections.size() > 1:
		begin_game()

func _on_character_select_1_pressed():
	toggle_character(1)


func _on_character_select_2_pressed():
	toggle_character(2)


func _on_character_select_3_pressed():
	toggle_character(3)


func _on_character_select_4_pressed():
	toggle_character(4)


func toggle_character(character):
	if character_selections.has(character):
		character_selections.erase(character)
	else:
		character_selections[character] = true

	draw_character_selections()

func draw_character_selections():
	for i in range(1, 5):
		if character_selections.has(i):
			toggle_selected(i, true)
		else:
			toggle_selected(i, false)

func toggle_selected(character, visible):
	if character == 1:
		$CharacterSelector1/CharacterSelect1/Selected.visible = visible
	elif character == 2:
		$CharacterSelector2/CharacterSelect2/Selected.visible = visible
	elif character == 3:
		$CharacterSelector3/CharacterSelect3/Selected.visible = visible
	elif character == 4:
		$CharacterSelector4/CharacterSelect4/Selected.visible = visible

func begin_game():
	var players = {}
	var i = 0

	for key in character_selections:
		players[i] = key
		i += 1

	PlayerManager.players = players
	PlayerManager.playerCount = i
	get_tree().change_scene_to_file("res://main_game/game_controller.tscn")
