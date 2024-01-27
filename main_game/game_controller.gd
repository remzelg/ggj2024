extends Control

# correlates a player number to a device number
var player_pawn_mapping = {}
var current_player = 0
@onready var curr_pawn = $Overworld/Pawns/Pawn
@onready var _library = $Overworld/Locations/Library
@onready var _apartment = $Overworld/Locations/Apartment
var tween

func _ready():
	player_pawn_mapping[0] = 0
	curr_pawn.position = _apartment.get_pos()
	for button in $UI/Options/Vbox.get_children():
		button.focus_entered.connect(_on_location_hovered.bind(button.name))
	$UI/Options/Vbox/Apartment.grab_focus()
func _process(delta):
	pass
	
func _input(event):
	pass

func _on_location_hovered(location_name):
	print(location_name)
	tween = get_tree().create_tween()
	tween.tween_property(curr_pawn, "position", get_node("Overworld/Locations/" + location_name).get_pos(), .5)
