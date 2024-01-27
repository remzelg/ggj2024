extends Control

@onready var tween
@onready var input = DeviceInput.new(-1)

@onready var next_marker_dict = {
	"Last": $"2DScene/Markers/OnDeck",
	"Next": $"2DScene/Markers/Active",
	"OnDeck": $"2DScene/Markers/Next",
	"Active": $"2DScene/Markers/Last"
}
var curr_player
var example = load("res://Resources/Dialogues/example.dialogue")

@onready var get_joke_container: Callable = func():
	return $UI/JokeBubbleContainer

func _ready():
	DialogueManager.get_current_scene = get_joke_container
	curr_player = PlayerManager.players[0]
	#DialogueManager.show_joke_balloon(example, "start")
	$"2DScene/Actors/Lion".curr_marker = "Active"
	$"2DScene/Actors/Possum".curr_marker = "Next"
	$"2DScene/Actors/Dolphin".curr_marker = "Last"
	$"2DScene/Actors/Bird".curr_marker = "OnDeck"

#func _process(delta):
	#if input.is_action_just_pressed("join"):
		#next_up()


func next_up():
	
	change_positions()
	
func tween_to_next_marker(actor):
	var next_marker = get_next_marker(actor.curr_marker)
	tween.parallel().tween_property(actor, "position",next_marker.position, .5)
	
	actor.curr_marker = next_marker.name

func get_next_marker(marker_name):
	for marker in $"2DScene/Markers".get_children():
		if marker.name == marker_name:
			return next_marker_dict[marker_name]

func change_positions():
	tween = get_tree().create_tween()
	for actor in $"2DScene/Actors".get_children():
		tween_to_next_marker(actor)
	tween.play()