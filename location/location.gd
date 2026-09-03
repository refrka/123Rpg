class_name Location extends Node2D




@export var ysort_root: Node2D







func add_entity_node(entity_node: EntityNode, target_position: Vector2) -> void:

	if entity_node.get_parent() != null:

		entity_node.get_parent().remove_child(entity_node)

	ysort_root.add_child(entity_node)

	entity_node.global_position = target_position