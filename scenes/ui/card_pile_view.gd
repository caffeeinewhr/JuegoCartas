class_name CardPileView
extends Control

const CARD_MENU_UI_SCENE := preload("res://scenes/ui/card_menu_ui.tscn")

@export var card_pile: CardPile

@onready var title : Label = %Title
@onready var cards : GridContainer = %Cards
@onready var card_tooltip_popup : CardTooltipPopup = %CardTooltipPopup
@onready var back_button : Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(hide)
	
	for card: Node in cards.get_children():
		card.queue_free()
		
