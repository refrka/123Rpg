class_name State extends Node




@export var allow_reenter:= false



var initialized:= false

var active:= false

var entity: EntityNode

var state_machine: StateMachine





func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	if initialized:

		return

	initialized = true

	entity = _entity

	state_machine = _state_machine









func get_state_name() -> String:

	return name.trim_suffix("State")



func get_state_script() -> Script:

	return get_script()











func _enter() -> void:

	active = true

	_connect_signals()




func _exit() -> void:

	active = false

	_disconnect_signals()




func _transition(state_script: Script) -> void:

	state_machine.request_state(state_script)





func _tick(_delta: float) -> void:

	pass










func _connect_signals() -> void:

	pass



func _disconnect_signals() -> void:

	pass