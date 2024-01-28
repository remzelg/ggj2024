extends VBoxContainer

@export var profile : Texture
@export var progress : int
@export var char_id : int
signal won()

func _ready():
	$Profile.texture = profile

func _process(_delta):
	$Popularity.value = progress


func _emit_won(val):
	if val >= 100:
		won.emit()
