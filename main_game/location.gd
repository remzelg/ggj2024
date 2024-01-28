extends AnimatedSprite2D
# Will be used to find the '_default' and '_selected' animations
@export var animation_prefix : String
@export var selected : bool
@export var splash : Texture
const _default = "_default"
const _selected = "_selected"

# Called when the node enters the scene tree for the first time.
func _ready():
	play(animation_prefix + _default)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected and (animation != (animation_prefix + _selected)):
		play(animation_prefix + _selected)

func get_pos():
	return to_global($Pivot.position)
	
func get_event():
	var location_name = get_name()

