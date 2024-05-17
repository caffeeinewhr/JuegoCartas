class_name AccionUI
extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var number: Label = $Number

func update_accion(accion: AccionEnemiga) -> void:
	if not accion:
		hide()
		return
		
	icon.texture = accion.icon
	icon.visible = icon.texture != null
	number.text = str(accion.number)
	number.visible = accion.number.length() > 0
	show()
