class_name IdleCommand extends Command


@export var timed:= true

@export var idle_duration_range:= Vector2(3.0, 7.0)


var idle_timer: SceneTreeTimer



func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.stop()

	if !timed:

		_set_result(Result.SUCCESS)

	else:

		var duration = randf_range(idle_duration_range.x, idle_duration_range.y)

		idle_timer = Game.get_tree().create_timer(duration)

		idle_timer.timeout.connect(_on_idle_timeout, CONNECT_ONE_SHOT)

		_set_result(Result.PENDING)

	return result






func _cancel() -> void:

	if idle_timer:

		idle_timer.timeout.disconnect(_on_idle_timeout)

	super()






func _on_idle_timeout() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit(self, result)