class_name Command extends Resource


@warning_ignore("unused_signal")


signal command_executed


enum Result {

	SUCCESS,

	FAILURE,

	PENDING,

	CANCELLED,

}


@export var await_result:= false

var result: Result



var blackboard: Blackboard



func _execute(_blackboard: Blackboard) -> Result:

	blackboard = _blackboard

	_set_result(Result.SUCCESS)

	return result




func _cancel() -> void:

	_set_result(Result.CANCELLED)

	command_executed.emit()






func _get_actor() -> EntityNode:

	return blackboard.get_value("actor")




func _set_result(_result: Result) -> void:

	result = _result




static func run(_blackboard: Blackboard) -> Result:

	return Result.SUCCESS