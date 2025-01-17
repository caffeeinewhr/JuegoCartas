class_name CardMenuUI
extends CenterContainer

signal tooltip_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = $Visuals/Panel
@onready var cost: Label = $Visuals/Label
@onready var icon: TextureRect = $Visuals/Icon

func _on_visuals_gui_input(event: InputEvent)-> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(card)
	
func _on_visuals_mouse_entered()->void:
	panel.set("theme_override_style/panel", HOVER_STYLEBOX)


func _on_visuals_mouse_exited()->void:
	panel.set("theme_override_style/panel", BASE_STYLEBOX)

func set_card(value: Card)-> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
