class_name HealthComponent extends Component


signal health_reduced

signal health_restored

signal health_depleted


var max_health: float

var current_health: float




func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	max_health = entity.entity_def.base_health

	current_health = max_health






func reduce_health(amount: float) -> void:

	current_health = max(0, current_health - amount)

	if current_health == 0:

		health_depleted.emit()

		entity.queue_free.call_deferred()

	else:

		health_reduced.emit()





func restore_health(amount: float) -> void:

	current_health = min(max_health, current_health + amount)

	health_restored.emit()









func receive_damage_package(damage_package: DamagePackage) -> void:

	for damage_entry in damage_package.damage_entries:

		reduce_health(damage_entry.amount)

		if !is_alive():

			break






func is_alive() -> bool:

	return current_health > 0.0