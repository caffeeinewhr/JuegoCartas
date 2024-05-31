# scripts/GlobalData.gd
extends Node

# Datos globales del jugador
var user_id: int = -1
var username: String = ""
var playtime: float = 0.0
var last_update_playtime: float = 0.0
var completed_levels: Array[int] = []
var kills: int = 0
var deaths: int = 0
var time_left: float = 40.0

func _ready():
	playtime = Time.get_ticks_msec() / 1000.0
	set_process(true)

func _process(_delta):
	var current_playtime = Time.get_ticks_msec() / 1000.0
	playtime += current_playtime - last_update_playtime
	last_update_playtime = current_playtime
	
func complete_level(level_number: int) -> void:
	if level_number not in completed_levels:
		completed_levels.append(level_number)

func increase_kills(kill_number: int) -> void:
	kills += kill_number
	
func increase_deaths(death_number: int) -> void:
	deaths += death_number
	
func set_playtime(time: int) -> void:
	playtime = time

func set_time_left(time: int) -> void:
	time_left = time

func reset_data() -> void:
	playtime = 0
	kills = 0
	deaths = 0
	time_left = 0
	completed_levels.clear()
