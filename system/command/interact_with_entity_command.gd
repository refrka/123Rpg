class_name InteractWithEntityCommand extends Command



var interaction_component: InteractionComponent



func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	_set_result(Result.PENDING)

	return result




func _cancel() -> void:

	super()




