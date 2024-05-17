extends EnemyAction

@export var block := 6

func perform_action() -> void:
	if not enemy or not target:
		return
		
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.execute([enemy])
	
	var tamanio_original = enemy.scale
	var tamanio_aumentado = tamanio_original * 1.2
	
	tween.tween_property(enemy, "scale", tamanio_aumentado, 0.2)
	tween.tween_interval(0.15)
	tween.tween_property(enemy, "scale", tamanio_original, 0.2)
	
	
	tween.finished.connect(
		func():
			Events.accion_enemiga.emit(enemy)
	)
