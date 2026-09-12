class_name BodyMovingState extends BodyState







func _enter() -> void:

	super()

	animation_component.play_moving_dir(get_body_dir())







func _connect_signals() -> void:

	movement_component.move_ended.connect(_on_move_ended)

	movement_component.face_dir_changed.connect(_on_face_dir_changed)





func _disconnect_signals() -> void:

	movement_component.move_ended.disconnect(_on_move_ended)

	movement_component.face_dir_changed.disconnect(_on_face_dir_changed)








func _on_move_ended() -> void:

	_transition(BodyIdleState)




func _on_face_dir_changed() -> void:

	animation_component.play_moving_dir(get_body_dir())