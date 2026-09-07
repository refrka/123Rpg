class_name MoveToEntityCommand extends Command


var target_entity: EntityNode


func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	_set_result(Result.PENDING)

	target_entity = blackboard.get_value("target_entity")

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished, CONNECT_ONE_SHOT)

	navigation_component.set_target_entity(target_entity)

	return result






func _cancel() -> void:

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.stop()

	navigation_component.navigation_finished.disconnect(_on_navigation_finished)




func _on_navigation_finished() -> void:

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.set_target_entity(null)

	_set_result(Result.SUCCESS)

	command_executed.emit(self, result)