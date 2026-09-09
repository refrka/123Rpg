class_name ContainerComponent extends InteractableComponent




func _start() -> void:

	var dialogue_overlay = UI.activate_overlay(ContainerOverlay)

	dialogue_overlay.overlay_closed.connect(_on_container_overlay_closed, CONNECT_ONE_SHOT)











func _on_container_overlay_closed() -> void:

	end_requested.emit()