extends Area2D


@export var button: Button

var thief: EntityNode

var player: Player


func _ready() -> void:

	body_entered.connect(_on_body_entered)

	button.pressed.connect(_on_button_pressed)

	player = get_tree().get_first_node_in_group("player")

	thief = get_tree().get_first_node_in_group("thief")




func _on_body_entered(body: PhysicsBody2D) -> void:

	if body is Player:

		return

	var behavior_component = body.get_component(BehaviorComponent)

	var behavior = behavior_component.behaviors[0]

	behavior.blackboard.set_value("target_entity", player)

	behavior_component._change_behavior(behavior)




func _on_button_pressed() -> void:

	var behavior_component = thief.get_component(BehaviorComponent)

	var i = randi_range(0, behavior_component.behaviors.size() - 1)

	var behavior = behavior_component.behaviors[i]

	behavior.blackboard.set_value("target_entity", player)

	behavior_component._change_behavior(behavior)