extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player

var isTimerStarted: bool = false

func _ready() -> void:
	AudioPlayer.play_music(preload("res://art/music/pelea.wav"), -3.0)
	await get_tree().create_timer(0.5).timeout
	$Timer.start()
	isTimerStarted = true
	#Esta parte se hará en las nuevas runs, porque se mantienen las estadisticas entre niveles
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

func _process(_delta):
	if (isTimerStarted):
		$BattleUI/Timer.label.text = str(int($Timer.time_left))
	
func start_battle(stats: CharacterStats) -> void:
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.fin_batalla_request.emit("Victoria!!", FinBatalla.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	
func _on_player_died() -> void:
	Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)

func _on_timer_timeout():
	if (isTimerStarted == true):
		Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)
