extends Panel
class_name TimerUI

@onready var label: Label = $Label

func _ready():
	update_label(GlobalData.time_left)
	set_process(true)

func _process(_delta):
	update_label(GlobalData.time_left)

func update_label(time_left: float) -> void:
	label.text = str(int(time_left))
