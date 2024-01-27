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
	#position = get_parent().get_parent().get_starting_position()

func _process(delta):
	var move = input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += move
