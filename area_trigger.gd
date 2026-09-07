extends Area2D





func _ready() -> void:

	body_entered.connect(_on_body_entered)




func _on_body_entered(body: PhysicsBody2D) -> void:

	if body.entity_def.entity_id != "thief":

		return

	var behavior_component = body.get_component(BehaviorComponent)

	var behavior = behavior_component.behaviors[3]

	var player = get_tree().get_first_node_in_group("player")

	behavior.blackboard.set_value("target_entity", player)

	behavior_component._change_behavior(behavior)