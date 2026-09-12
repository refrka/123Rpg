class_name BodyIdleState extends BodyState







func _enter() -> void:

	super()

	animation_component.play_idle_dir(get_body_dir())






func _connect_signals() -> void:

	if movement_component:

		movement_component.move_started.connect(_on_move_started)





func _disconnect_signals() -> void:

	if movement_component:

		movement_component.move_started.disconnect(_on_move_started)








func _on_move_started() -> void:

	_transition(BodyMovingState)