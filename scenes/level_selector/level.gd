extends Control
class_name Level

@onready var normal: Control = $Normal
@onready var boss: Control = $Boss
@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var battleScene: String

@export var number: int = 0
@export var isCompleted: bool = false
@export var isPlayable: bool = false
@export var isFirstLevel: bool = false
@export var isBossBattle: bool = false
