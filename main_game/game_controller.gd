extends Control

var current_pawn_name = "Lion"
var current_player = 0
var last_location
@onready var curr_pawn = $Overworld/Pawns/Pawn

var currentTurn:int = -1
var playerPtr:int = -1
var totalTurns:int = -1
signal game_end
signal turn_end

@onready var _library = $Overworld/Locations/Library
@onready var _apartment = $Overworld/Locations/Apartment
@onready var _bar = $Overworld/Locations/Bar

var turns_init = false

@onready var get_ui_node: Callable = func():
	return $UI

@onready var tween

func _ready():
	DialogueManager.get_current_scene = get_ui_node
	DialogueManager.dialogue_ended.connect(_on_dialogue_exited)
	
	DialogueHelper.powerup.connect(_on_powerup)

	curr_pawn.position = _apartment.get_pos()
	for button in $UI/Options/Vbox.get_children():
		button.focus_entered.connect(_on_location_hovered.bind(button.name))
		button.pressed.connect(_on_location_selected.bind(button.name))
	$UI/Options/Vbox/Apartment.grab_focus()
	tick()
	
func init_player(playerId:int) -> void:
	current_player = playerId
	
	var player_device = PlayerManager.get_player_device(playerId)
	if player_device == 1:
		current_pawn_name = "Possum"
	elif player_device == 2:
		current_pawn_name = "Bird"
	elif player_device == 3:
		current_pawn_name = "Lion"
	else:
		current_pawn_name = "Dolphin"
	curr_pawn.init(playerId)

func tick() -> void:
	if !turns_init:
		# TODO read from settings or something
		totalTurns = 3
		currentTurn = 1
		playerPtr = -1
		turns_init = true

	playerPtr += 1
	if playerPtr == PlayerManager.playerCount:
		turn_end.emit()
		currentTurn += 1
		playerPtr = 0

	if currentTurn > totalTurns:
		game_end.emit()
		return

	var nextPlayer = PlayerManager.get_player_ids()[playerPtr]
	init_player(nextPlayer)
	print("tick\n\tturns " + str(currentTurn) + "/" + str(totalTurns) + "\n\tptrs " + str(playerPtr) + " for " + str(PlayerManager.get_player_ids()) + "\n\t\t" + str(PlayerManager.playerCount))
	
func get_location_node(location_name):
	for child in $Overworld/Locations.get_children():
		if child.name == location_name:
			return child

func _input(event):
	if Input.is_action_pressed("ui_accept") and $UI/ConfirmPopup.visible:
		$UI/ConfirmPopup.visible = false
		_on_confirmation_yes()

func _on_location_hovered(location):
	tween = get_tree().create_tween()
	tween.tween_property(curr_pawn, "position",_location_pos_from_name(location) , .5)

func _on_location_selected(location_name):
	last_location = location_name
	$UI/ConfirmPopup.visible = true
	$UI/ConfirmPopup.grab_focus()

# this is when a player's turn ends
func _on_dialogue_exited(_resource):
	# Save stat changes when dialogue box closes
	var changes = EventManager.get_event_effects()
	PlayerManager.save_stat_changes(current_player, changes)
	tick()

func _location_pos_from_name(location):
	return get_node("Overworld/Locations/" + location).get_pos()

func _button_node_from_name(location):
	return get_node("UI/Options/Vbox/" + location)
	
func _on_confirmation_yes():
	var locationEvent:LocationEvent = load("res://Resources/LocationEvents/" + last_location + ".tres")
	locationEvent = locationEvent.for_tags(["character:" + current_pawn_name])
	DialogueManager.show_dialogue_balloon(locationEvent.dialogue_target(), locationEvent.dialogue_title(), [get_location_node(last_location).splash])

func _on_confirmation_no():
	_button_node_from_name(last_location).grab_focus()

func _on_game_end():
	get_tree().change_scene_to_file("res://showdown/showdown.tscn")
	
func _on_powerup(joke_id):
	var joke_path = "res://Resources/Jokes/" + joke_id + ".tres"
	var joke = load(joke_path)
	PlayerManager.add_joke(current_player, joke)	 
