extends Control

# correlates a player number to a device number
var player_pawn_mapping = {}
var current_player = 0
var curr_pawn 
;
func _ready():
	player_pawn_mapping[0] = 0
	curr_pawn = $Pawns.get_child(current_player)

func _process(delta):
	pass
	
func _input(event):
	pass
