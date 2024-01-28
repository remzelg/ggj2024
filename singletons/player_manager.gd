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
	0: load("res://Resources/stats/possum-player.tres").duplicate(true),
	1: load("res://Resources/stats/bird-player.tres").duplicate(),
	2: load("res://Resources/stats/lion-player.tres").duplicate(),
	3: load("res://Resources/stats/dolphin-player.tres").duplicate(),
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

	resource.stats.wit += changes["wit"]
	resource.stats.pride += changes["pride"]
	resource.stats.obs += changes["obs"]
	resource.stats.delivery += changes["delivery"]
	ResourceSaver.save(resource, resource.get_path())

func add_joke(player, new_joke):
	var character = player_resources[player]
	
	character.jokes.append(new_joke)

func get_player_ids() -> Array[int]:
	if !_initialized:
		_initialized = true
		for i in playerCount:
			player_ids.append(i)
	return player_ids
