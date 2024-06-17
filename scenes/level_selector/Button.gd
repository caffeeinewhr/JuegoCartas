extends Button

@onready var level: Level = $".."
@onready var audio: Node = $"../Audio"

func _on_pressed():
	if level.is_playable:
		audio.get_node("Click").play()
		GlobalData.current_level = level.number
		SceneTransition.load_scene(level.battle_scene)
		print("Level pressed: " + str(GlobalData.current_level))
	
func _on_mouse_entered():
	audio.get_node("Hover").play()
	label_visibility(true)
		
func _on_mouse_exited():
	label_visibility(false)
		
func label_visibility(visibility: bool) -> void:
	level.label.visible = visibility
	if level.is_boss_battle:
		level.boss.visible = visibility
	else:
		level.normal.visible = visibility
