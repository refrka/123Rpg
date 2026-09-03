class_name Blackboard extends RefCounted


signal changed(key: StringName)



var data: Dictionary



func set_value(key: StringName, value: Variant) -> void:

	data[key] = value

	changed.emit(key)



func get_value(key: StringName, default = null) -> Variant:

	return data.get(key, default)



func erase_value(key: StringName) -> void:

	if data.erase(key):

		changed.emit(key)




func clear() -> void:

	data.clear()