extends Area2D


@export var button: Button

var entity: EntityNode

var player: Player


func _ready() -> void:

	body_entered.connect(_on_body_entered)

	button.pressed.connect(_on_button_pressed)

	player = get_tree().get_first_node_in_group("player")




func _on_body_entered(body: PhysicsBody2D) -> void:

	if !entity:

		entity = body

	var behavior_component = body.get_component(BehaviorComponent)

	var behavior = behavior_component.behaviors[0]

	behavior_component._change_behavior(behavior)




func _on_button_pressed() -> void:

	if !entity:

		return

	var behavior_component = entity.get_component(BehaviorComponent)

	var i = randi_range(0, behavior_component.behaviors.size() - 1)

	var behavior = behavior_component.behaviors[i]

	behavior_component._change_behavior(behavior)