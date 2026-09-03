class_name Component extends Node




var initialized:= false

var active:= false

var entity: EntityNode







func _initialize(_entity: EntityNode) -> void:

	if initialized:

		return

	initialized = true

	entity = _entity








func get_component_name() -> String:

	return name.trim_suffix("Component")
	


func get_component_script() -> Script:

	return get_script()











func _activate() -> void:

	active = true

	_connect_signals()




func _deactivate() -> void:

	active = false

	_disconnect_signals()




func _connect_signals() -> void:

	pass



func _disconnect_signals() -> void:

	pass