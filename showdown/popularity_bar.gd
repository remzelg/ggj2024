extends VBoxContainer

@export var profile : Texture
@export var progress : int

func _ready():
	$Profile.texture = profile
	progress = 20

func _process(delta):
	$Popularity.value = progress

