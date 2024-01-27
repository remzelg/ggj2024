extends Marker2D

@export var player_id: int = 0
var input

func init(id):
	player_id = id
	var device = PlayerManager.get_player_device(player_id)
	input = DeviceInput.new(device)

func _ready():
	var device = PlayerManager.get_player_device(player_id)
	input = DeviceInput.new(device)

func get_pos():
	return 
