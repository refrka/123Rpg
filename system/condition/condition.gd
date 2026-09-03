class_name Condition extends Resource



enum {

	FAIL,

	PASS,

}



var blackboard: Blackboard



func _evaluate(_blackboard: Blackboard) -> bool:

	blackboard = _blackboard

	return PASS