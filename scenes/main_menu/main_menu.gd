extends Control

	
func _on_play_button_pressed():
	$Audio/NormalClick.play()
	SceneTransition.load_scene("res://scenes/level_selector/level_selector.tscn")
	
	
func _on_quit_button_pressed():
	$Audio/ExitClick.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_play_button_mouse_entered():
	$Audio/Hover.play()


func _on_quit_button_mouse_entered():
	$Audio/Hover.play()

