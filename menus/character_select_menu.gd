extends Control

var players = [-2, -2, -2, -2]

func _on_texture_button1_pressed():
	var active_player = get_active_player()

	players[active_player] = 1

func _on_texture_button2_pressed():
	var active_player = get_active_player()

	players[active_player] = 2

func get_active_player():
	return 1
