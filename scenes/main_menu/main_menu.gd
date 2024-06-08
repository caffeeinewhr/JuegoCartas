extends Control

@onready var label_error = $Form/LabelError
@onready var input_username = $Form/LineEditUsername
@onready var input_password = $Form/LineEditPassword
@onready var label_welcome = $AnimatedBackground/LabelWelcome

func _ready():
	AudioPlayer.play_music(preload("res://art/music/demo_menu.wav"))
	Api.connect("user_validation_completed", Callable(self, "_on_user_validation_completed"))
	Api.connect("user_update_completed", Callable(self, "_on_user_update_completed"))
	Api.connect("user_stats_retrieved", Callable(self, "_on_user_stats_retrieved"))

func _on_play_button_pressed():
	$Audio/NormalClick.play()
	SceneTransition.load_scene("res://scenes/level_selector/level_selector.tscn")

func _on_quit_button_pressed():
	$Audio/ExitClick.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_log_button_pressed():
	$Audio/NormalClick.play()
	$Form.show()

func _on_confirm_button_pressed():
	$Audio/NormalClick.play()
	
	var username = input_username.text
	var password = input_password.text
	
	if username == "" and password == "":
		label_error.text = "Please write your username and password"
		label_error.show()
	elif username == "" and password != "":
		label_error.text = "Please write your username"
		label_error.show()
	elif username != "" and password == "":
		label_error.text = "Please write your password"
		label_error.show()
	else:
		Api.validate_user(username, password)

func _on_user_validation_completed(success: bool):
	if not success:
		label_error.text = "User does not exist"
		label_error.show()
	else:
		label_welcome.text = "Welcome " + GlobalData.username + "!"
		$Form.hide()
		print("User validated successfully")
		Api.get_user_stats(GlobalData.username)

func _on_user_stats_retrieved(success: bool, stats: Dictionary):
	if success:
		GlobalData.kills = stats.get('kills', 0)
		GlobalData.deaths = stats.get('deaths', 0)
		GlobalData.increase_deaths(1)
		print("User stats retrieved and updated in GlobalData")
	else:
		print("Failed to retrieve user stats")
		
func _on_user_update_completed(success: bool):
	if success:
		print("User stats updated successfully")
	else:
		print("Failed to update user stats")
			
func _on_close_button_pressed():
	$Audio/NormalClick.play()
	$Form.hide()
	
func _on_play_button_mouse_entered():
	$Audio/Hover.play()

func _on_quit_button_mouse_entered():
	$Audio/Hover.play()

func _on_log_button_mouse_entered():
	$Audio/Hover.play()
