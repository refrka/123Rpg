class_name Command extends Resource


@warning_ignore("unused_signal")


signal command_executed(command: Command, result: Result)

signal result_changed(result: Result)


enum Result {

	SUCCESS,

	FAILURE,

	PENDING,

	CANCELLED,

}

@export var display_name: String

@export var await_result:= false



var blackboard: Blackboard

var result: Result







func _execute(_blackboard: Blackboard) -> Result:

	blackboard = _blackboard

	_set_result(Result.SUCCESS)

	return result




func _cancel() -> void:

	_set_result(Result.CANCELLED)

	print("_cancel emitting")

	command_executed.emit(self, result)




func _get_actor() -> EntityNode:

	return blackboard.get_value("actor")



func _set_result(_result: Result) -> void:

	result = _result

	result_changed.emit(result)




static func run(_blackboard: Blackboard) -> Result:

	return Result.SUCCESS