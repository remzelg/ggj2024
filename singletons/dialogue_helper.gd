extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal powerup(joke_id)

func emit(signal_name, signal_value):
	if signal_name == "powerup":
		powerup.emit(signal_value)
