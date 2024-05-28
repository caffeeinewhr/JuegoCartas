extends Control


func _on_button_pressed():
	Events.battle_rewards_exited.emit()
