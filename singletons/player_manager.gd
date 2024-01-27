extends Node

var playerCount = 0
var players = {0: -1}
var devices = {}


func get_player_device(player_id):
	return players[player_id]
