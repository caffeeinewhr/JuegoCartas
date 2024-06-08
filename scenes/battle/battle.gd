extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player
@onready var timer_real: Timer = $TimerReal 
@onready var timer_ui: TimerUI = $BattleUI/Timer

var isTimerStarted: bool = false

func _ready() -> void:
	AudioPlayer.play_music(preload("res://art/music/pelea.wav"), -3.0)
	await get_tree().create_timer(0.5).timeout
	timer_real.start()
	isTimerStarted = true
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)

	start_battle(new_stats)
	battle_ui.initialize_card_pile_ui()
	
	GlobalData.set_timer_real_path($TimerReal.get_path())

func _process(_delta):
	if (isTimerStarted):
		GlobalData.set_time_left(timer_real.time_left)
		timer_ui.update_label(GlobalData.time_left)

func start_battle(stats: CharacterStats) -> void:
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		GlobalData.increase_kills(1)
		Events.fin_batalla_request.emit("Victoria!!", FinBatalla.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	
func _on_player_died() -> void:
	print(GlobalData.deaths)
	GlobalData.increase_deaths(1)
	print(GlobalData.deaths)
	Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)

func _on_timer_timeout():
	if (isTimerStarted):
		GlobalData.increase_deaths(1)
		Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)
