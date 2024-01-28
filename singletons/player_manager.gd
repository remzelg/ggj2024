extends Node

var playerCount:int = 0
# players is a mapping of player:int --> player_device:int
# player_device is also used for character reference
# blue is 1
# yellow is 2
# red is 3
# green is 4
var players = {0: -1}
var devices = {}
var player_resources = {0: load("res://Resources/stats/player-0-stats.tres")}
var _initialized = false
var player_ids:Array[int] = []

func get_player_device(player_id):
	return players[player_id]

func set_player_resources(player_id, resource):
	player_resources[player_id] = resource

func save_stat_changes(player, changes):
	var resource = player_resources[player]

	var stats = resource.stats
	stats.wit += changes["wit"]
	stats.pride += changes["pride"]
	stats.obs += changes["obs"]
	stats.delivery +- changes["delivery"]
	
	ResourceSaver.save(stats, stats.get_path())

func get_player_ids() -> Array[int]:
	if !_initialized:
		_initialized = true
		for i in playerCount:
			player_ids.append(i)
	return player_ids
