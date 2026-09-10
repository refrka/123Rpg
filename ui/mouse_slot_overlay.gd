class_name MouseSlotOverlay extends UIOverlay



@export var item_slot: ItemSlot

var origin_slot: ItemSlot






func hold_slot(_origin_slot: ItemSlot) -> void:

	origin_slot = _origin_slot

	item_slot.set_data(origin_slot.item_data)

	UI.activate_overlay(MouseSlotOverlay)

	item_slot._update_count_label()

	item_slot._update_texture()
	




func drop_slot() -> void:

	item_slot.clear()

	UI.deactivate_overlay(MouseSlotOverlay)





func clear() -> void:
	
	origin_slot = null

	item_slot.clear()

	UI.deactivate_overlay(MouseSlotOverlay)





func _unhandled_input(event: InputEvent) -> void:

	if visible:

		if event is InputEventMouseButton:

			if !item_slot.is_empty():

				drop_slot()






func _process(_delta: float) -> void:

	if visible:

		global_position = get_global_mouse_position()

		