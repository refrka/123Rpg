class_name TickEffect extends Effect


@export var tick_count:= 0

@export var tick_rate:= 0.0







func _do_tick(_target_entity: EntityNode) -> void:

	_apply_effect(_target_entity)