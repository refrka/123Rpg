class_name InteractWithEntityCommand extends Command



var interaction_component: InteractionComponent



func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	interaction_component = _get_actor().get_component(InteractionComponent)

	interaction_component.interaction_complete.connect(_on_interaction_complete, CONNECT_ONE_SHOT)

	var target_entity = blackboard.get_value("target_entity")

	interaction_component._start_interaction(target_entity)

	_set_result(Result.PENDING)

	return result




func _cancel() -> void:

	interaction_component._cancel_interaction()

	interaction_component.interaction_complete.disconnect(_on_interaction_complete)

	super()





func _on_interaction_complete() -> void:

	print("done interacting")

	_set_result(Result.SUCCESS)

	command_executed.emit()


