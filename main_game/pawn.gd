extends Marker2D

@export var player_id: int = 0
var input

# player_device is also used for character reference
# blue is 1
# yellow is 2
# red is 3
# green is 4
var device_texture_1 = load("res://assets/Art/7AA50B42-9F93-4491-A4CC-A65958FCE7AF.png")
var device_texture_2 = load("res://assets/Art/92FFDE75-71EF-40D6-91EB-1D8E1E0E76BB.png")
var device_texture_3 = load("res://assets/Art/99DE88A1-1911-496B-9A05-3F681775346E.png")
var device_texture_4 = load("res://assets/Art/4CD18E62-F569-4D46-849C-477430EFCF19.png")

func init(id):
	player_id = id
	var device = PlayerManager.get_player_device(player_id)
	input = DeviceInput.new(device)
	_set_sprite(device)

func _ready():
	var device = PlayerManager.get_player_device(player_id)
	input = DeviceInput.new(device)

func get_pos():
	return 

func _set_sprite(device):
	$Sprite.texture = _texture_for_device(device)
	
func _texture_for_device(device):
	if device == 1:
		return device_texture_1
	elif device == 2:
		return device_texture_2
	elif device == 3:
		return device_texture_3
	else:
		return device_texture_4
