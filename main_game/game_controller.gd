extends Control

# correlates a player number to a device number
var player_pawn_mapping = {}
var current_player = 0
var last_location
@onready var curr_pawn = $Overworld/Pawns/Pawn
@onready var _library = $Overworld/Locations/Library
@onready var _apartment = $Overworld/Locations/Apartment

@onready var example = load("res://Resources/Dialogues/example.dialogue")

@onready var get_ui_node: Callable = func():
	return $UI

var tween

func _ready():
	DialogueManager.get_current_scene = get_ui_node
	DialogueManager.dialogue_ended.connect(_on_dialogue_exited)

	player_pawn_mapping[0] = 0
	curr_pawn.position = _apartment.get_pos()
	for button in $UI/Options/Vbox.get_children():
		button.focus_entered.connect(_on_location_hovered.bind(button.name))
		button.pressed.connect(_on_location_selected.bind(button.name))
	$UI/Options/Vbox/Apartment.grab_focus()
	
	
func _process(delta):
	pass
	
func _input(event):
	pass

func _on_location_hovered(location):
	tween = get_tree().create_tween()
	tween.tween_property(curr_pawn, "position",_location_pos_from_name(location) , .5)

func _on_location_selected(location_name):
	last_location = location_name
	$UI/ConfirmPopup.visible = true
	

func _on_dialogue_exited(_resource):
	var button = _button_node_from_name(last_location)
	button.grab_focus()

func _location_pos_from_name(location):
	return get_node("Overworld/Locations/" + location).get_pos()

func _button_node_from_name(location):
	return get_node("UI/Options/Vbox/" + location)

func _on_confirmation_yes():
	DialogueManager.show_dialogue_balloon(example, "start")

func _on_confirmation_no():
	_button_node_from_name(last_location).grab_focus()
	pass

