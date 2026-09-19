class_name MoveToLastKnownPositionCommand extends Command





func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var target_disposition = blackboard.get_value("target_disposition")

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	navigation_component.set_target_position(target_disposition.last_known_position)

	_set_result(Result.PENDING)

	return result






func _cancel() -> void:

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.disconnect(_on_navigation_finished)

	navigation_component.stop()






func _on_navigation_finished() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit()