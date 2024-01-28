extends Control
var winner = 1
func init(winner_id):
	winner = winner_id
# Called when the node enters the scene tree for the first time.
func _ready():
	$Node.get_children()[winner].visible = true
	$AudioStreamPlayer.play()
	$AudioStreamPlayer2.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
