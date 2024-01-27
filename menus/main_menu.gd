extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_button_pressed():
	$SplashMenu.set_visible(true)
	$SettingsMenu.visible = true # Replace with function body.


func _on_back_button_pressed():
	$SettingsMenu.visible = false
	$SplashMenu.visible = true # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit() # Replace with function body.


func _on_start_button_pressed():
	pass
