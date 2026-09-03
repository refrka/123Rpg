class_name Command extends Resource


@warning_ignore("unused_signal")


signal command_executed(result: Result)


enum Result {

	SUCCESS,

	FAILURE,

	PENDING,

	CANCELLED,

}


@export var await_result:= false



var blackboard: Blackboard



func _execute(_blackboard: Blackboard) -> Result:

	blackboard = _blackboard

	return Result.SUCCESS




func _cancel() -> void:

	command_executed.emit(Result.CANCELLED)




func _get_actor() -> EntityNode:

	return blackboard.get_value("actor")




static func run(_blackboard: Blackboard) -> Result:

	return Result.SUCCESS