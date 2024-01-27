extends Node

var playerCount = 0
var players = {0: -1}
var devices = {}
var player_resources = {0: load("res://Resources/stats/player-0.tres")}

func get_player_device(player_id):
	return players[player_id]

func set_player_resources(player_id, resource):
	player_resources[player_id] = resource
