class_name FinBatalla
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continueButton: Button = %ContinueButton   
@onready var restartButton: Button = %RestartButton 


func _ready()-> void:
	continueButton.pressed.connect(get_tree().quit)
	restartButton.pressed.connect(get_tree().quit)
	Events.fin_batalla_request.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continueButton.visible = type == Type.WIN
	restartButton.visible = type == Type.LOSE
	show()
	get_tree().paused = true
