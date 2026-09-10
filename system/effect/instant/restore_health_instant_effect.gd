class_name RestoreHealthInstantEffect extends InstantEffect


@export var amount: float




func _apply_effect(target_entity: EntityNode) -> void:

	var health_component = target_entity.get_component(HealthComponent)

	health_component.restore_health(amount)

	