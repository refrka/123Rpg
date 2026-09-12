class_name IdleCommand extends Command



@export var idle_duration_range:= Vector2(2.0, 5.0)

var idle_timer: SceneTreeTimer





func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.stop()

	idle_timer = Game.get_tree().create_timer(_get_duration())

	idle_timer.timeout.connect(_on_idle_timeout)

	_set_result(Result.PENDING)

	return result






func _get_duration() -> float:

	return randf_range(idle_duration_range.x, idle_duration_range.y)





func _on_idle_timeout() -> void:

	idle_timer = null

	_set_result(Result.SUCCESS)

	command_executed.emit()