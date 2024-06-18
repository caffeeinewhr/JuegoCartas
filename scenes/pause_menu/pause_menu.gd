extends Control

var isPaused: bool = false

func _ready():
	if GlobalData.username.is_empty():
		$VBoxContainer/SaveButton.hide()

func _input(event):
	if event.is_action_pressed("pause"):
		$Audio/ExitClick.play()
		pauseMenu()

func pauseMenu():
	isPaused = !isPaused
	if isPaused:
		$".".show()
		get_tree().paused = true
	else:
		$".".hide()
		get_tree().paused = false

func _on_music_button_pressed():
	$Audio/NormalClick.play()
	if AudioPlayer.isVolumeUp:
		$VBoxContainer/MusicButton.set_text("Music: OFF") 
	else:
		$VBoxContainer/MusicButton.set_text("Music: ON") 
	AudioPlayer.change_mute()

func _on_resume_button_pressed():
	$Audio/ExitClick.play()
	pauseMenu()

func _on_quit_button_pressed():
	$Audio/ExitClick.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_menu_button_pressed():
	$Audio/ExitClick.play()
	get_tree().paused = false

	# Get the battle scene node and disconnect the signal
	var battle_scene_path = "/root/Battle"
	var battle_scene = get_node(battle_scene_path)
	if battle_scene:
		battle_scene.cleanup_battle()
		
	SceneTransition.load_scene("res://scenes/main_menu/main_menu.tscn")

func _on_music_button_mouse_entered():
	$Audio/Hover.play()

func _on_resume_button_mouse_entered():
	$Audio/Hover.play()

func _on_menu_button_mouse_entered():
	$Audio/Hover.play()

func _on_quit_button_mouse_entered():
	$Audio/Hover.play()

func _on_save_button_mouse_entered():
	$Audio/Hover.play()

func _on_save_button_pressed():
	Api.update_user_stats()
