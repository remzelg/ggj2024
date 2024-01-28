extends Node

var playerCount:int = 0
# players is a mapping of player:int --> player_device:int
# player_device is also used for character reference
# blue is 1
# yellow is 2
# red is 3
# green is 4
var players = {}
var devices = {}

@onready var player_resources = {
	0: load("res://Resources/stats/possum-player.tres"),
	1: load("res://Resources/stats/bird-player.tres"),
	2: load("res://Resources/stats/lion-player.tres"),
	3: load("res://Resources/stats/dolphin-player.tres"),
}

var _initialized = false

var name_to_player_int_map = {
	"possum" : 1,
	"bird" : 2,
	"lion" : 3,
	"dolphin" : 4
}

var player_ids:Array[int] = []

func get_player_device(player_id):
	return players[player_id]

func save_stat_changes(player, changes):
	var resource = player_resources[player]

	var stats = resource.stats
	stats.wit += changes["wit"]
	stats.pride += changes["pride"]
	stats.obs += changes["obs"]
	stats.delivery += changes["delivery"]

func get_player_ids() -> Array[int]:
	if !_initialized:
		_initialized = true
		for i in playerCount:
			player_ids.append(i)
	return player_ids
