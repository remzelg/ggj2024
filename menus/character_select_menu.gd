extends Control

var active_player = 0
var selected_character = -1
var players = [0, 0, 0] # delete once singleton is all setup

func _on_texture_button1_pressed():
	selected_character = 1

	lock_start_button()

func _on_texture_button2_pressed():
	selected_character = 2

	lock_start_button()

func _on_start_pressed():
	if all_players_selected():
		get_tree().change_scene_to_file('res://menus/main_menu.tscn')
	else:
		if selected_character <= 0:
			return

		select_character(active_player, selected_character)

		if all_players_selected():
			$VBoxContainer2/StartButton.text = 'start'

func lock_start_button():
	var start_button = $VBoxContainer2/StartButton

	start_button.text = 'Accept'

func select_character(player, character):
	var start_button = $VBoxContainer2/StartButton

	players[active_player] = selected_character
	start_button.text = 'Select Your Character'
	active_player += 1

func all_players_selected():
	players.all(func(number): return number > 0)
