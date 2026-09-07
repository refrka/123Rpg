class_name MoveToPositionCommand extends Command



var navigation_component: NavigationComponent

@export var target_position: Vector2




func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var _target_position = blackboard.get_value("target_position", null)

	if _target_position != null:

		target_position = _target_position

	navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	navigation_component.set_target_position(target_position)

	_set_result(Result.PENDING)

	return result






func _cancel() -> void:

	navigation_component.navigation_finished.disconnect(_on_navigation_finished)

	navigation_component.stop()

	super()






func _on_navigation_finished() -> void:

	command_executed.emit()