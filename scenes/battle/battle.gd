extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player
@onready var timer_real: Timer = $TimerReal
@onready var timer_ui: TimerUI = $BattleUI/Timer
@onready var rewards_layer: CanvasLayer = $Rewards
@onready var battle_rewards: Node = rewards_layer.get_node("BattleReward")

var is_timer_started: bool = false
var is_battle_active: bool = true  # New flag to indicate if the battle is active

func _ready() -> void:
	print("Battle started")
	AudioPlayer.play_music(preload("res://art/music/pelea.wav"), -3.0)
	await get_tree().create_timer(0.5).timeout
	timer_real.wait_time = GlobalData.time_left
	timer_real.start()
	is_timer_started = true
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)

	Events.fin_batalla_request.connect(_on_fin_batalla_request)

	start_battle(new_stats)
	battle_ui.initialize_card_pile_ui()
	
	GlobalData.set_timer_real_path($TimerReal.get_path())

	rewards_layer.hide()

func _process(_delta):
	if is_timer_started:
		GlobalData.set_time_left(timer_real.time_left)
		timer_ui.update_label(GlobalData.time_left)

func start_battle(stats: CharacterStats) -> void:
	is_battle_active = true  # Ensure battle is active at the start
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void:
	if is_battle_active and enemy_handler.get_child_count() == 0:
		print("All enemies defeated")
		GlobalData.increase_kills(1)
		GlobalData.complete_level()
		Events.fin_batalla_request.emit("Victoria!!", FinBatalla.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_player_died() -> void:
	if is_battle_active:
		print("Player died")
		GlobalData.increase_deaths(1)
		Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)

func _on_timer_timeout():
	if is_timer_started:
		print("Timer timeout")
		GlobalData.increase_deaths(1)
		Events.fin_batalla_request.emit("Derrota", FinBatalla.Type.LOSE)

func _on_fin_batalla_request(result: String, type: int):
	print("Battle finished with result: ", result)
	is_battle_active = false  # Set battle active to false when battle ends
	hide_current_scene()
	if type == FinBatalla.Type.WIN:
		show_battle_reward()
	else:
		show_fin_batalla(result)

func hide_current_scene():
	print("Hiding current scene")
	self.hide()

func show_battle_reward():
	if is_instance_valid(rewards_layer):
		print("Showing battle reward")
		rewards_layer.show()
		if is_instance_valid(battle_rewards):
			battle_rewards.visible = true

func show_fin_batalla(result: String): 
	if is_instance_valid(rewards_layer):
		print("Showing fin batalla scene with result: ", result)
		rewards_layer.show()
		if is_instance_valid(battle_rewards):
			battle_rewards.visible = false
		var fin_batalla_scene = preload("res://scenes/battle_reward/battle_reward.tscn").instantiate()
		rewards_layer.add_child(fin_batalla_scene)
		fin_batalla_scene.set_result(result)

func cleanup_battle():
	print("Cleaning up battle")
	is_battle_active = false
	if enemy_handler.child_order_changed.is_connected(self._on_enemies_child_order_changed):
		enemy_handler.child_order_changed.disconnect(_on_enemies_child_order_changed)
