extends Control

var isPaused: bool = false


func _input(event):
	if event.is_action_pressed("pause"):
		$Audio/ExitClick.play()
		pauseMenu()
		
			
func pauseMenu():
	isPaused = !isPaused
	if isPaused:
		$".".show()
		AudioSettings.volume = -5.0
		get_tree().paused = true
	else:
		$".".hide()
		AudioSettings.volume = 0.0
		get_tree().paused = false


func _on_music_button_pressed():
	$Audio/NormalClick.play()
	if AudioSettings.isVolumeUp:
		$VBoxContainer/MusicButton.set_text("Music: ON") 
		AudioSettings.isVolumeUp = false
	else:
		$VBoxContainer/MusicButton.set_text("Music: OFF") 
		AudioSettings.isVolumeUp = true
	
	
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
	SceneTransition.load_scene("res://scenes/main_menu/main_menu.tscn")
	

func _on_music_button_mouse_entered():
	$Audio/Hover.play()


func _on_resume_button_mouse_entered():
	$Audio/Hover.play()


func _on_menu_button_mouse_entered():
	$Audio/Hover.play()


func _on_quit_button_mouse_entered():
	$Audio/Hover.play()
