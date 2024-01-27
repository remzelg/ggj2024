extends Node

var playerCount:int = 0
var players = {0: -1}
var devices = {}
var player_resources = {0: load("res://Resources/stats/player-0-stats.tres")}
var _initialized = false
var player_ids:Array[int] = []

func get_player_device(player_id):
	return players[player_id]

func set_player_resources(player_id, resource):
	player_resources[player_id] = resource
	
func get_player_ids() -> Array[int]:
	if !_initialized:
		for i in playerCount:
			player_ids.append(i)
	return player_ids
