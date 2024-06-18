extends EnemyAction

@export var damage := 5

func perform_action() -> void:
	if not enemy or not target:
		return
	var tween := create_tween().set_trans(Tween.TRANS_QUINT) #para mover al enemigo
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32 #el 32 es para que no se ponga encima del personaje
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target] #es un array porque apra el damageEffect se necesitaba, pero solo metemos el target en el array
	damage_effect.amount = damage
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array)) #hacemos el daño al llegar al enemigo
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)

	tween.finished.connect(
		func():
			Events.accion_enemiga.emit(enemy)
	)
