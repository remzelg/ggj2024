extends Control

func move_to_character_select():
	get_tree().change_scene_to_file("res://menus/character_select_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_settings_button_pressed():
	$SplashMenu.set_visible(false)
	$SettingsMenu.set_visible(true)

func _on_settings_back_button_pressed():
	$SettingsMenu.visible = false
	$SplashMenu.visible = true # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit() # Replace with function body.

func _on_start_button_pressed():
	$AnimationPlayer.play("fade out")
	$Fader.set_visible(true)
	PlayerManager.playerCount = $PlayerCountMenu/OptionButton.selected

func _on_audio_slider_value_changed(value):
	GameSettings.audioLevel = value

func _on_player_count_back_button_pressed():
	$PlayerCountMenu.set_visible(false)
	$SplashMenu.set_visible(true) # Replace with function body.


func _on_splash_start_button_pressed():
	$PlayerCountMenu.set_visible(true)
	$SplashMenu.set_visible(false) # Replace with function body.
