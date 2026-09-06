class_name InteractionSensor extends Sensor



func _on_body_entered_sensor(body: PhysicsBody2D) -> void:

	if body is EntityNode and body != entity:

		if body.is_interactable():

			super(body)