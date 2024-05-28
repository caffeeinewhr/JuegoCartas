extends Node

signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

signal accion_enemiga(enemy: Enemy)
signal enemy_turn_ended

signal fin_batalla_request(text: String, type: FinBatalla.Type)
signal batalla_ganada

signal map_exited

signal battle_rewards_exited
