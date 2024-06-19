extends Node

# Datos globales del jugador
var username: String = ""
var playtime: float = 0.0
var last_update_playtime: float = 0.0
var completed_levels: Array[int] = []
var current_level: int = 1
var kills: int = 0
var deaths: int = 0
var time_left: float = 90.0
var timer_real: Timer = null

const BASE_CARD_REWARDS := 3
const BASE_COMMON_WEIGHT := 6.0
const BASE_UNCOMMON_WEIGHT := 3.7
const BASE_RARE_WEIGHT := 0.3

@export var card_rewards: Array[Card] = []
@export_range(0.0, 10.0) var common_weight := BASE_COMMON_WEIGHT
@export_range(0.0, 10.0) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0, 10.0) var rare_weight := BASE_RARE_WEIGHT

func _ready():
	playtime = Time.get_ticks_msec() / 1000.0
	set_process(true)
	# Inicializar card_rewards como un array si no lo está ya
	if card_rewards.size() == 0:
		card_rewards = []
		print("Initialized card_rewards as an empty array")

func _process(_delta):
	var current_playtime = Time.get_ticks_msec() / 1000.0
	playtime += current_playtime - last_update_playtime
	last_update_playtime = current_playtime
	
	if is_instance_valid(timer_real):
		time_left = timer_real.time_left

func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT

func set_timer_real_path(path: NodePath):
	timer_real = get_node(path)

func complete_level() -> void:
	if current_level not in completed_levels:
		completed_levels.append(current_level)
		print("Nivel completado: " + str(current_level))

func increase_kills(kill_number: int) -> void:
	kills += kill_number
	print("Kills aumentado")
	
func increase_deaths(death_number: int) -> void:
	deaths += death_number
	print("Muertes aumentado")
	
func set_playtime(time: int) -> void:
	playtime = time

func set_time_left(time: float) -> void:
	time_left = time
	if is_instance_valid(timer_real):
		timer_real.wait_time = time
		timer_real.start()

func add_time(seconds: float) -> void:
	time_left += seconds
	if is_instance_valid(timer_real):
		timer_real.wait_time += seconds
		timer_real.start()

func subtract_time(seconds: float) -> void:
	time_left = max(time_left - seconds, 0)
	if is_instance_valid(timer_real):
		timer_real.wait_time = max(timer_real.wait_time - seconds, 0)
		timer_real.start()

func reset_data() -> void:
	playtime = 0
	kills = 0
	deaths = 0
	time_left = 90.0
	completed_levels.clear()
	if is_instance_valid(timer_real):
		timer_real.wait_time = 0
