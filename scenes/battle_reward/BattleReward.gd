class_name BattleReward
extends Control

const CARD_REWARDS = preload("res://scenes/ui/card_reward.tscn")
const REWARD_BUTTON = preload("res://scenes/ui/reward_button.tscn")
const CARD_ICON := preload("res://art/tutorial/rarity.png")
const CARD_TEXT := "Add new Card"

var run_stats: GlobalData
@export var character_stats: CharacterStats

@onready var rewards: VBoxContainer = %Rewards

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.COMMON: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.RARE: 0.0,
}

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()

	# Obtener referencia a GlobalData
	run_stats = get_tree().root.get_node("GlobalData")  # Asegúrate de que la ruta es correcta

	if not run_stats:
		push_error("GlobalData node not found")
		return

	# Inicializar character_stats si es necesario
	if not character_stats:
		character_stats = preload("res://characters/warrior/warrior.tres").create_instance()
		print("Initialized character_stats")

	add_card_reward()
	add_card_reward()

func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)

func _show_card_rewards() -> void:
	print("Button pressed - _show_card_rewards called")

	if not run_stats or not character_stats:
		print("run_stats or character_stats is null")
		return

	# Imprimir tipo y contenido de run_stats.card_rewards para depuración
	print("run_stats.card_rewards type: %s" % typeof(run_stats.card_rewards))
	print("run_stats.card_rewards content: %s" % str(run_stats.card_rewards))

	# Verificar si run_stats.card_rewards es un array
	if typeof(run_stats.card_rewards) != TYPE_ARRAY:
		push_error("run_stats.card_rewards should be an array")
		return

	# Instanciar y añadir card_rewards a la escena
	var card_rewards := CARD_REWARDS.instantiate() as CardReward
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	# Configurar y mostrar las recompensas de cartas
	var card_rewards_array: Array[Card] = []
	var available_cards: Array[Card] = character_stats.draftable_cards.cards.duplicate(true)

	# Verificar y depurar available_cards
	print("available_cards: %s" % str(available_cards))

	if available_cards.size() == 0:
		push_error("No available cards to draft")
		return

	for i in range(run_stats.BASE_CARD_REWARDS):  # Cambiado a un bucle fijo basado en BASE_CARD_REWARDS
		_setup_card_chances()
		var roll := randf_range(0.0, card_reward_total_weight)

		for rarity: Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards, rarity)
				card_rewards_array.append(picked_card)
				available_cards.erase(picked_card)
				break
				
	card_rewards.rewards = card_rewards_array
	card_rewards.show()

	# Depurar card_rewards.rewards
	print("card_rewards.rewards: %s" % str(card_rewards.rewards))

	# Ocultar los botones de añadir carta
	for node in rewards.get_children():
		node.hide()
		
func _setup_card_chances() -> void:
	card_reward_total_weight = run_stats.common_weight + run_stats.uncommon_weight + run_stats.rare_weight        
	card_rarity_weights[Card.Rarity.COMMON] = run_stats.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = run_stats.common_weight + run_stats.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE] = card_reward_total_weight

func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.RARE:
		run_stats.rare_weight = GlobalData.BASE_RARE_WEIGHT
	else:
		run_stats.rare_weight = clampf(run_stats.rare_weight + 0.3, GlobalData.BASE_RARE_WEIGHT, 5.0)

func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card):
			return card.rarity == with_rarity
	)
	return all_possible_cards.pick_random()        

func _on_card_reward_taken(card: Card) -> void:
	if not character_stats or not card:
		return
	
	print("Deck Before:\n%s\n" % character_stats.deck)
	if card:
		character_stats.deck.add_card(card)
	print("Deck After:\n%s\n" % character_stats.deck)    
		
	# Mostrar un mensaje de éxito o realizar otras acciones necesarias
	print("Card reward taken or skipped")
	
	# Volver a mostrar los botones de añadir carta si es necesario
	for node in rewards.get_children():
		node.show()
	
func _on_back_button_pressed():
	Events.fin_batalla_request.emit()
