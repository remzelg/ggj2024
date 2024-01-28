extends Control

@onready var tween
@onready var input = DeviceInput.new(-1)

@onready var PopRow = $UI/Panel/Margin/Row

@onready var win_screen = load("res://win_screen.tscn")
const HIT_FACTOR = 0.01
var curr_player = -1
var curr_joke_results

@onready var get_joke_container: Callable = func():
	return $UI/JokeBubbleContainer

func _ready():
	get_right_characters()
	$AudioStreamPlayer.stream.set_loop(true)
	DialogueManager.get_current_scene = get_joke_container
	DialogueManager.dialogue_ended.connect(_on_joke_finished)


func next_up():
	if curr_player == PlayerManager.playerCount - 1:
		curr_player = 0
	else:
		curr_player = curr_player + 1
	change_positions()
	$UI/JokeChoicePanel.show()
	$UI/JokeChoicePanel.prep_player(get_player_resource(curr_player))

func get_right_characters():
	for id in PlayerManager.players:
		var char_node = $"2DScene/Actors".get_child(PlayerManager.players[id]-1)
		char_node.present = true
		char_node.curr_marker = $"2DScene/Markers".get_child(id)
		char_node.position = char_node.curr_marker.position
		if curr_player == -1:
			curr_player = id
	for child in $"2DScene/Actors".get_children():
		if !child.present:
			child.queue_free()
			var last_marker = $"2DScene/Markers".get_children()[-1]
			last_marker.get_parent().remove_child(last_marker)
			last_marker.queue_free()
			$UI/Panel/Margin/Row.get_children()[child.get_index()].queue_free()
	for child in PopRow.get_children():
			child.won.connect(_on_player_won.bind(child.char_id))

func tween_to_next_marker(actor):
	var next_marker = get_next_marker(actor.curr_marker)
	tween.parallel().tween_property(actor, "position",next_marker.position, .5)
	
	actor.curr_marker = next_marker

func get_next_marker(curr_marker):
	if curr_marker == $"2DScene/Markers".get_children()[0]:
		return $"2DScene/Markers".get_children()[-1]
	else: 
		return $"2DScene/Markers".get_child(curr_marker.get_index() - 1)

func change_positions():
	tween = get_tree().create_tween()
	for actor in $"2DScene/Actors".get_children():
		tween_to_next_marker(actor)
	tween.play()

func get_player_resource(player_id):
	var char_id = PlayerManager.players[player_id]
	return PlayerManager.player_resources[char_id]

func _on_joke_chosen(joke):
	DialogueManager.show_joke_balloon(load(joke.dialogue), "start")
	prepare_joke_results(joke)

func _on_joke_finished(_joke_dialogue):
	resolve_joke()

func get_actor_from_player_id(curr_player):
	var char_name = get_player_resource(curr_player).character.name
	for actor in $"2DScene/Actors".get_children():
		if actor.character_name == char_name.to_lower():
			return actor

func resolve_joke():
	var actor = get_actor_from_player_id(curr_player)
	actor.process_mode = Node.PROCESS_MODE_DISABLED
	tween = get_tree().create_tween()
	if curr_joke_results.hit:
		var curr_player_pop = get_node("UI/Panel/Margin/Row/Popularity" + str(PlayerManager.players[curr_player]))
		tween.parallel().tween_property(curr_player_pop, "progress", curr_player_pop.progress + curr_joke_results.pop_inc, 0.5)
		if curr_joke_results.has("target"): 
			var target_pop = get_node("UI/Panel/Margin/Row/Popularity" + str(curr_joke_results.target))
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
	var res = get_player_resource(curr_player)
	var key_stat = ""
	match joke.category:
		"Observe":
			key_stat = res.stats.obs
		"Outsmart":
			key_stat = res.stats.wit
		"Roast":
			key_stat = res.stats.pride
			
	return randi_range(1, joke.difficulty) <= randi_range(1, res.stats.delivery)

func _on_player_won(ind):
	var scene = win_screen.instantiate()
	scene.init(ind)
	get_parent().add_child(scene)
	queue_free()

func calc_pop_inc(joke):
	var res = get_player_resource(curr_player)
	match joke.category:
		"Roast":
			return joke.difficulty * res.stats.pride * HIT_FACTOR
		"Observe":
			return joke.difficulty * res.stats.obs * HIT_FACTOR
		"Outsmart":
			return joke.difficulty * res.stats.wit * HIT_FACTOR

func calc_pop_hit(joke):
	return get_player_resource(joke.target).stats.pride * joke.difficulty
