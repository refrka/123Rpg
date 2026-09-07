class_name BodyIdleState extends BodyState








func _connect_signals() -> void:

	var movement_component = entity.get_component(MovementComponent)

	if movement_component:

		movement_component.move_started.connect(_on_move_started)





func _disconnect_signals() -> void:

	var movement_component = entity.get_component(MovementComponent)

	if movement_component:

		movement_component.move_started.disconnect(_on_move_started)








func _on_move_started() -> void:

	_transition(BodyMovingState)