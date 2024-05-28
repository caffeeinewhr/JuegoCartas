class_name Run
extends Node

const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const MAP_SCENE := preload("res://scenes/level_selector/level_selector.tscn")
const BATTLE_REWARDS_SCENE := preload("res://scenes/battle_rewards.tscn")

@onready var current_view: Node = $CurrentView

var character: CharacterStats

func _ready()-> void:
	if not character:
		var warrior := load("res://characters/warrior/warrior.tres")
		character = warrior.create_instance()
		_start_run()
		
func _start_run() -> void:
	_setup_event_connections()
	print("aqui se pondria el mapa (creo KJDSHFKL)")

func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
func _setup_event_connections() -> void:
	Events.batalla_ganada.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	Events.battle_rewards_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	
func _on_map_exited() -> void:
	print("TAL")
