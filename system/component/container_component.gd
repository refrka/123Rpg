class_name ContainerComponent extends InteractableComponent











func _start_interacting() -> bool:

	super()

	return true





func _end_interacting() -> bool:

	super()

	return true







func _load_ui() -> void:

	UI.activate_overlay(ContainerOverlay)



func _unload_ui() -> void:

	UI.deactivate_overlay(ContainerOverlay)