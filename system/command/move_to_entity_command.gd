class_name MoveToEntityCommand extends Command



var navigation_component: NavigationComponent

var target_entity: EntityNode









func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	target_entity = blackboard.get_value("target_entity")

	if !target_entity:

		_set_result(Result.FAILURE)

		return result

	navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	navigation_component.set_target_entity(target_entity)

	_set_result(Result.PENDING)

	return result





func _cancel() -> void:

	navigation_component.navigation_finished.disconnect(_on_navigation_finished)

	navigation_component.stop()

	super()





func _on_navigation_finished() -> void:

	navigation_component.stop()

	_set_result(Result.SUCCESS)

	command_executed.emit()