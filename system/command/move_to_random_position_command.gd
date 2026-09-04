class_name MoveToRandomPositionCommand extends Command


@export var distance_range:= Vector2(100.0, 250.0)







func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var actor = _get_actor()

	var navigation_component = actor.get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	var dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

	var distance = randf_range(distance_range.x, distance_range.y)

	navigation_component.set_target_position(actor.global_position + dir * distance)

	_set_result(Result.PENDING)

	return result






func _cancel() -> void:

	pass







func _on_navigation_finished() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit(self, result)