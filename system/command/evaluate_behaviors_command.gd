class_name EvaluateBehaviorsCommand extends Command






func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var behavior_component = _get_actor().get_component(BehaviorComponent2)

	behavior_component._evaluate_behavior_list.call_deferred()

	_set_result(Result.SUCCESS)

	command_executed.emit()

	return result