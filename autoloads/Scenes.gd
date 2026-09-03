extends Node







func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS









func get_location() -> Location:

	var location = get_tree().get_first_node_in_group("location")

	return location