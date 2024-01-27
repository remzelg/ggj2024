extends Panel

signal yes()
signal no()

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/Yes.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_yes():
	yes.emit()
	visible = false

func _on_no():
	no.emit()
	visible = false
