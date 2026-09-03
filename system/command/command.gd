class_name Command extends Resource


@warning_ignore("unused_signal")


signal command_executed(result: Result)


enum Result {

	SUCCESS,

	FAILURE,

	PENDING,

	CANCELLED,

}



var blackboard: Blackboard



func _execute(_blackboard: Blackboard) -> Result:

	blackboard = _blackboard

	return Result.SUCCESS