extends Node









func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS











func pause() -> void:

	get_tree().paused = true



func unpause() -> void:

	get_tree().paused = false









func is_active() -> bool:

	return true


func is_paused() -> bool:

	return get_tree().paused