extends Control

var input_device
var player

signal leave

func init(player_num: int, device: int):
	input_device = DeviceInput.new(device)
	player = player_num

func _ready():
	pass


func _process(delta):
	#TODO: Add checks for UI controls from player
	if input_device.is_action_just_pressed("join"):
		leave.emit(player)
