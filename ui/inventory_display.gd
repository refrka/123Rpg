class_name InventoryDisplay extends UIElement


@onready var item_slot_scene:= preload("res://ui/item_slot.tscn")


@export var inventory_grid: GridContainer


var current_inventory: Inventory

var current_hovered_slot: ItemSlot

var current_selected_slot: ItemSlot




func load_inventory(inventory: Inventory) -> void:

	for child in inventory_grid.get_children():

		child.queue_free()

	current_inventory = inventory

	for item_data in current_inventory.item_list:

		var item_slot = item_slot_scene.instantiate()

		inventory_grid.add_child(item_slot)

		item_slot.set_data(item_data)







func handle_slot_select_input(item_slot: ItemSlot, pressed: bool) -> void:

	var mouse_overlay = UI.get_overlay(MouseSlotOverlay)

	match [item_slot.is_empty(), mouse_overlay.item_slot.is_empty(), pressed]:

		[false, true, true]: # Clicking non-empty slot, nothing held

			mouse_overlay.hold_slot(item_slot)

		[false, false, true]: # Clicking non-empty slot, slot held

			if item_slot == mouse_overlay.origin_slot:

				mouse_overlay.drop_slot()

			elif item_slot.item_data.can_accept(mouse_overlay.item_slot.item_data.item_def):

				item_slot.item_data.add_data(mouse_overlay.item_slot.item_data)

				if mouse_overlay.item_slot.is_empty():

					mouse_overlay.drop_slot()

		[true, false, true]: # Clicking empty slot, slot held

			item_slot.item_data.assign_data(mouse_overlay.origin_slot.item_data)

			mouse_overlay.origin_slot.item_data.set_data(null, 0)

			mouse_overlay.clear()


