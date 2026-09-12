class_name MoveToRandomPositionCommand extends Command



@export var speed_factor:= 1.0

@export var distance_range:= Vector2(50.0, 200.0)

@export var dir_x_range:= Vector2(-1.0, 1.0)

@export var dir_y_range:= Vector2(-1.0, 1.0)




var navigation_component: NavigationComponent




func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var actor = _get_actor()

	navigation_component = actor.get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	var dir = _get_dir()

	var dist = _get_distance()

	navigation_component.set_target_position(actor.global_position + (dir * dist))

	_set_result(Result.PENDING)

	return result






func _cancel() -> void:

	if navigation_component.navigation_finished.is_connected(_on_navigation_finished):

		navigation_component.navigation_finished.disconnect(_on_navigation_finished)








func _get_dir() -> Vector2:

	return Vector2(randf_range(dir_x_range.x, dir_x_range.y), randf_range(dir_y_range.x, dir_y_range.y))



func _get_distance() -> float:

	return randf_range(distance_range.x, distance_range.y)









func _on_navigation_finished() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit()

