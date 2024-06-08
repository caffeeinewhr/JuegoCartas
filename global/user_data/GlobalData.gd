extends Node

# Datos globales del jugador
var username: String = ""
var playtime: float = 0.0
var last_update_playtime: float = 0.0
var completed_levels: Array[int] = []
var kills: int = 0
var deaths: int = 0
var time_left: float = 40.0
var timer_real: Timer = null

func _ready():
	playtime = Time.get_ticks_msec() / 1000.0
	set_process(true)

func _process(_delta):
	var current_playtime = Time.get_ticks_msec() / 1000.0
	playtime += current_playtime - last_update_playtime
	last_update_playtime = current_playtime
	
	if timer_real:
		time_left = timer_real.time_left

func set_timer_real_path(path: NodePath):
	timer_real = get_node(path)

func complete_level(level_number: int) -> void:
	if level_number not in completed_levels:
		completed_levels.append(level_number)

func increase_kills(kill_number: int) -> void:
	kills += kill_number
	
func increase_deaths(death_number: int) -> void:
	deaths += death_number
	
func set_playtime(time: int) -> void:
	playtime = time

func set_time_left(time: float) -> void:
	time_left = time
	if timer_real:
		timer_real.wait_time = time
		timer_real.start()

func add_time(seconds: float) -> void:
	time_left += seconds
	if timer_real:
		timer_real.wait_time += seconds
		timer_real.start()

func subtract_time(seconds: float) -> void:
	time_left = max(time_left - seconds, 0)
	if timer_real:
		timer_real.wait_time = max(timer_real.wait_time - seconds, 0)
		timer_real.start()

func reset_data() -> void:
	playtime = 0
	kills = 0
	deaths = 0
	time_left = 0
	completed_levels.clear()
	if timer_real:
		timer_real.wait_time = 0
