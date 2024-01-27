extends Control

# correlates a player number to a device number
var player_pawn_mapping = {}
var current_player = 0
@onready var curr_pawn = $Overworld/Pawns/Pawn
@onready var _library = $Overworld/Locations/Library
;
func _ready():
	player_pawn_mapping[0] = 0
	curr_pawn.position = _library.get_pos()
	for button in $UI/Options/Vbox.get_children():
		button.pressed.connect(_on_location_selected)

func _process(delta):
	pass
	
func _input(event):
	pass

func _on_location_selected():
	pass


func _on_location_pressed(extra_arg_0):
	pass # Replace with function body.
