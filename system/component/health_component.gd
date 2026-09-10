class_name HealthComponent extends Component


signal health_depleted

signal health_restored(amount: float, current_health: float)

signal health_reduced(amount: float, current_health: float)




var max_health: float

var current_health: float





func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var entity_def = entity.entity_def

	max_health = entity_def.base_health

	current_health = max_health







func receive_damage_package(damage_package: DamagePackage) -> void:

	for damage_entry in damage_package.damage_entries:

		if entity is Player:

			Game.camera.anim_player.play("shake")

		reduce_health(damage_entry.amount)





func restore_health(amount: float) -> void:

	if is_alive():

		current_health += amount

		health_restored.emit(amount, current_health)





func reduce_health(amount: float) -> void:

	if is_alive():

		current_health -= amount

		health_reduced.emit(amount, current_health)

		if !is_alive():

			var animation_component = entity.get_component(AnimationComponent)

			if animation_component.combat_anim_player.is_playing():

				await animation_component.combat_anim_player.animation_finished

			health_depleted.emit()

			entity.queue_free.call_deferred()







func get_ratio() -> float:

	return current_health / max_health




func is_alive() -> bool:

	return current_health > 0.0



func is_critical() -> bool:

	return current_health / max_health <= 0.25