extends Node




var overlay_root: Control

var overlay_registry: Dictionary[Script, UIOverlay]

var active_overlays: Array[UIOverlay]





func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS

	overlay_root = get_tree().get_first_node_in_group("overlay_root")








func activate_overlay(overlay_script: Script) -> UIOverlay:

	var overlay = get_overlay(overlay_script)

	if overlay:

		active_overlays.append(overlay)

		overlay._activate()

		overlay.show()

		if overlay.pause_game and !Game.is_paused():

			Game.pause()

	return overlay





func deactivate_overlay(overlay_script: Script) -> UIOverlay:

	var overlay = get_overlay(overlay_script)
	
	if overlay:

		active_overlays.erase(overlay)

		overlay._deactivate()

		overlay.hide()

		if overlay.pause_game:

			var pause_overlays = active_overlays.filter(func(o): return o.pause_game)

			if pause_overlays.is_empty():

				Game.unpause()

	return overlay






func register_overlay(overlay: UIOverlay) -> void:

	var overlay_script = overlay.get_script()

	overlay_registry[overlay_script] = overlay






func unregister_overlay(overlay: UIOverlay) -> void:

	var overlay_script = overlay.get_script()

	if overlay_registry.has(overlay_script):

		overlay_registry.erase(overlay_script)










func get_overlay(overlay_script: Script) -> UIOverlay:

	if overlay_registry.has(overlay_script):

		return overlay_registry[overlay_script]

	return null









func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("back"):

		if Game.is_active():

			if active_overlays.is_empty():

				activate_overlay(GameMenu)

			else:

				var overlay = active_overlays.back()

				deactivate_overlay(overlay.get_script())