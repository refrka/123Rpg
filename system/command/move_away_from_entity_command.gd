class_name MoveAwayFromEntityCommand extends Command


@export var distance_range:= Vector2(50.0, 100.0)


var navigation_component: NavigationComponent


func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var actor = _get_actor()

	var target_entity = blackboard.get_value("target_entity")

	if !is_instance_valid(target_entity):

		_set_result(Result.FAILURE)

		return result

	var dir = target_entity.global_position.direction_to(actor.global_position)

	var dist = _get_distance()

	navigation_component = actor.get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	navigation_component.set_target_position(actor.global_position + (dir * dist))

	_set_result(Result.PENDING)

	return result




func _cancel() -> void:

	navigation_component.stop()

	navigation_component.navigation_finished.disconnect(_on_navigation_finished)





func _get_distance() -> float:

	return randf_range(distance_range.x, distance_range.y)






func _on_navigation_finished() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit()