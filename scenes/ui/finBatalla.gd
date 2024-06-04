class_name FinBatalla
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continueButton: Button = %ContinueButton   


func _ready()-> void:
	continueButton.pressed.connect(func(): Events.batalla_ganada.emit())
	Events.fin_batalla_request.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continueButton.visible = type == Type.WIN
	show()
	get_tree().paused = true
