class_name FinBatalla
extends Control

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continueButton: Button = %ContinueButton

@onready var rewardScene: PackedScene = preload("res://scenes/battle_reward/battle_reward.tscn")

func _ready() -> void:
	continueButton.pressed.connect(func(): Events.batalla_ganada.emit())
	Events.fin_batalla_request.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	# Pausar el juego
	get_tree().paused = true
	
	if type == Type.WIN:
		var rewardInstance = rewardScene.instantiate()
		get_tree().root.add_child(rewardInstance)
		hide()
	else:
		label.text = text
		continueButton.visible = true
		show()
