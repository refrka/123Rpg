extends Node



var active:= false



func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS





func _activate() -> void:

	active = true

	UI.activate_overlay(DebugOverlay)




func _deactivate() -> void:

	active = false

	UI.deactivate_overlay(DebugOverlay)






func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("debug"):

		if !active:

			_activate()

		else:

			_deactivate()

		
