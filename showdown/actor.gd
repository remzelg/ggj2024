extends AnimatedSprite2D

@export var character_name : String
@export var character : Resource
@export var curr_marker : String
@onready var _default = character_name + "_default"
@onready var _talking = character_name + "_talking"
@onready var _happy = character_name + "_happy"
@onready var _sad = character_name + "_sad"
# Called when the node enters the scene tree for the first time.
func _ready():
	play(_default)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curr_marker == "Active":
		z_index = 2
		if animation != _talking:
			play(_talking)
	else:
		z_index = 1
		if curr_marker == "Last":
			z_index = 0
		if animation == _talking:
			play(_default)
	pass

func play_string(string):
	play(character_name + string)
