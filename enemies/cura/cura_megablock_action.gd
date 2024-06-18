extends EnemyAction

@export var block := 15
@export var hp_limite := 6

var usado := false


func is_performable() -> bool:
	if not enemy or not usado:
		return false
		
	var vida_baja := enemy.stats.health <= hp_limite
	usado = vida_baja
	
	return vida_baja

func perform_action() -> void:
	if not enemy or not target:
		return
		
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.accion_enemiga.emit(enemy)
	)

