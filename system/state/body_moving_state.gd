class_name BodyMovingState extends BodyState










func _connect_signals() -> void:

	var movement_component = entity.get_component(MovementComponent)

	movement_component.move_ended.connect(_on_move_ended)





func _disconnect_signals() -> void:

	var movement_component = entity.get_component(MovementComponent)

	movement_component.move_ended.disconnect(_on_move_ended)








func _on_move_ended() -> void:

	_transition(BodyIdleState)