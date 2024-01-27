extends Control

@onready var input = DeviceInput.new(-1)
func _ready():
	
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

## The action to use for advancing the dialogue
const NEXT_ACTION = &"ui_accept"

## The action to use to skip typing the dialogue
const SKIP_ACTION = &"ui_cancel"

@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false


## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		dialogue_label.focus_mode = Control.FOCUS_ALL
		# The dialogue has finished so close self
		if not next_dialogue_line:
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line


		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
	get:
		return dialogue_line

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
	)

func check_typing():
	if dialogue_label.is_typing:
		if input.is_action_just_pressed("join"):
			dialogue_label.skip_typing()
		return true
	return false

func _input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if check_typing(): return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if input.is_action_just_pressed("join"):
		next(dialogue_line.next_id)

func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

