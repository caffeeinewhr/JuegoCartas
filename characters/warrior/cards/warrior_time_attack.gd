extends Card

func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 2
	damage_effect.execute(targets)
	
	# Añadir 5 segundos al timer
	GlobalData.add_time(5)
