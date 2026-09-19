class_name IdleCommand extends Command



@export var idle_duration_range:= Vector2(2.0, 5.0)

@export var face_dir:= Vector2.ZERO

var idle_timer: SceneTreeTimer





func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	if face_dir != Vector2.ZERO:

		var movement_component = _get_actor().get_component(MovementComponent)

		movement_component.set_face_dir(face_dir)

		var animation_component = _get_actor().get_component(AnimationComponent)

		animation_component.play_idle_dir(face_dir)

	idle_timer = Game.get_tree().create_timer(_get_duration())

	idle_timer.timeout.connect(_on_idle_timeout)

	_set_result(Result.PENDING)

	return result




func _cancel() -> void:

	if idle_timer:

		idle_timer.timeout.disconnect(_on_idle_timeout)

	super()






func _get_duration() -> float:

	return randf_range(idle_duration_range.x, idle_duration_range.y)





func _on_idle_timeout() -> void:

	idle_timer = null

	_set_result(Result.SUCCESS)

	command_executed.emit()