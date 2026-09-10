class_name ContainerComponent extends InteractableComponent




func _start() -> void:

	var container_overlay = UI.activate_overlay(ContainerOverlay)

	container_overlay.overlay_closed.connect(_on_container_overlay_closed, CONNECT_ONE_SHOT)

	container_overlay.load_container_inventory(entity.inventory)
	





func _end() -> void:

	UI.deactivate_overlay(ContainerOverlay)







func _on_container_overlay_closed() -> void:

	end_requested.emit()