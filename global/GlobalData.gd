# scripts/GlobalData.gd
extends Node

# Datos globales del jugador
var playtime: float = 0
var completed_levels: Array[int] = []
var kills: int
var deaths: int
var time_left: int

# Cosas de bases de datos

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
