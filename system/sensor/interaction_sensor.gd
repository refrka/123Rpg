class_name InteractionSensor extends Sensor







func _on_body_entered_sensor(body: PhysicsBody2D) -> void:

	if body is EntityNode:

		var interactable_component = body.get_interactable_component()

		if interactable_component:

			super(body)