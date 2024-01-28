extends TextureRect

@export var curr_player : Resource
signal joke_chosen(joke)

var joke_option_scene = load("res://showdown/joke_option.tscn")
var chosen_category : String

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_player = PlayerManager.player_resources[PlayerManager.players[0]]
	for child in $Categories.get_children():
		child.pressed.connect(_on_category_selected.bind(child.name))

func _on_category_selected(category):
	chosen_category = category
	change_categories_visibility(false)
	$BackButton.show()
	load_jokes()
	$Margins.visible = true

func prep_player(new_player):
	curr_player = new_player
	$Margins.visible = false
	for child in $Categories.get_children():
		child.visible = true
	

func change_categories_visibility(show):
	for child in $Categories.get_children():
		child.visible = show

func load_jokes():
	for child in $Margins/Column.get_children():
		$Margins/Column.remove_child(child)
		child.queue_free()
	
	for joke in curr_player.get_all_jokes():
		if joke.category == chosen_category:
			var joke_option = joke_option_scene.instantiate()
			joke_option.init(joke)
			$Margins/Column.add_child(joke_option)
			joke_option.pressed.connect(_on_option_chosen.bind(joke))

	$Margins.visible = true

func _on_option_chosen(joke):
	hide()
	joke_chosen.emit(joke)
	


func _on_back_button_pressed():
	$Margins.hide()
	$BackButton.hide()
	for child in $Categories.get_children():
		child.show()
	pass # Replace with function body.
