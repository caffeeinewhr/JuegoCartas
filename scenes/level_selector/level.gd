extends Control
class_name Level

@onready var normal: Control = $Normal
@onready var boss: Control = $Boss
@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var battle_scene: String

@export var number: int = 0
@export var is_completed: bool = false
@export var is_playable: bool = false
@export var is_first_level: bool = false
@export var is_boss_battle: bool = false
