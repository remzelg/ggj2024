extends Control

@onready var tween
@onready var input = DeviceInput.new(-1)

@onready var next_marker_dict = {
	"Last": $"2DScene/Markers/OnDeck",
	"Next": $"2DScene/Markers/Active",
	"OnDeck": $"2DScene/Markers/Next",
	"Active": $"2DScene/Markers/Last"
}
@onready var PopRow = $UI/Panel/Margin/Row.get_children()

const HIT_FACTOR = 0.01
var curr_player
var curr_joke_results
var example = load("res://Resources/Dialogues/example.dialogue")

@onready var get_joke_container: Callable = func():
	return $UI/JokeBubbleContainer

func _ready():
	$AudioStreamPlayer.stream.set_loop(true)
	DialogueManager.get_current_scene = get_joke_container
	DialogueManager.dialogue_ended.connect(_on_joke_finished)

	curr_player = 0
	#DialogueManager.show_joke_balloon(example, "start")
	$"2DScene/Actors/Lion".curr_marker = "OnDeck"
	$"2DScene/Actors/Possum".curr_marker = "Active"
	$"2DScene/Actors/Dolphin".curr_marker = "Last"
	$"2DScene/Actors/Bird".curr_marker = "Next"

func next_up():
	if curr_player == 3:
		curr_player = 0
	else:
		curr_player = curr_player + 1
	change_positions()
	$UI/JokeChoicePanel.show()
	$UI/JokeChoicePanel.prep_player(PlayerManager.player_resources[curr_player])

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

func _on_joke_chosen(joke):
	DialogueManager.show_joke_balloon(load(joke.dialogue), "start")
	prepare_joke_results(joke)

func _on_joke_finished(_joke_dialogue):
	resolve_joke()

func resolve_joke():
	var actor = $"2DScene/Actors".get_child(curr_player)
	actor.process_mode = Node.PROCESS_MODE_DISABLED
	tween = get_tree().create_tween()
	if curr_joke_results.hit:
		var curr_player_pop = get_node("UI/Panel/Margin/Row/Popularity" + str(curr_player+1))
		tween.parallel().tween_property(curr_player_pop, "progress", curr_player_pop.progress + curr_joke_results.pop_inc, 0.5)
		if curr_joke_results.has("target"): 
			var target_pop = get_node("UI/Panel/Margin/Row/Popularity" + str(curr_joke_results.target+1))
			tween.parallel().tween_property(target_pop, "progress", curr_joke_results.pop_hit, 0.5)
		%AudienceAnim.play("react")
		AudioManager.play_fx("cheer")
		tween.play()
		actor.play_string("_happy")
		await %AudienceAnim.animation_finished
		AudioManager.play_fx("good")
	# TODO: audience animation tween
	else:
		# TODO: sad character here
		actor.play_string("_sad")
		AudioManager.play_fx("boo")
		%AudienceAnim.play("react")
		await %AudienceAnim.animation_finished
		AudioManager.play_fx("bad")
	actor.process_mode = Node.PROCESS_MODE_INHERIT
	actor.play_string("_default")
	next_up()
	
func prepare_joke_results(joke):
	curr_joke_results = joke # do joke calc
	curr_joke_results = {}
	curr_joke_results.hit = check_hit(joke)
	if curr_joke_results.hit:
		curr_joke_results.pop_inc = calc_pop_inc(joke)
	if joke.target:
		curr_joke_results.pop_hit = calc_pop_hit(joke)
		curr_joke_results.target = joke.target
	
func check_hit(joke):
	var res = PlayerManager.player_resources[curr_player]
	var key_stat = ""
	match joke.category:
		"Observe":
			key_stat = res.stats.obs
		"Outsmart":
			key_stat = res.stats.wit
		"Roast":
			key_stat = res.stats.pride
			
	return (randi_range(1, 50) + joke.difficulty) <= (res.stats.delivery + key_stat)


func calc_pop_inc(joke):
	var res = PlayerManager.player_resources[curr_player]
	match joke.category:
		"Roast":
			return joke.difficulty * res.stats.pride * HIT_FACTOR
		"Observe":
			return joke.difficulty * res.stats.obs * HIT_FACTOR
		"Outsmart":
			return joke.difficulty * res.stats.wit * HIT_FACTOR

func calc_pop_hit(joke):
	var res = PlayerManager.player_resources[curr_player]
	return PlayerManager.player_resources[joke.target].stats.pride * joke.difficulty
