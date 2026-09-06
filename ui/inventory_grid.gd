class_name InventoryGrid extends UIElement


@onready var item_slot_scene:= preload("res://ui/item_slot.tscn")



var inventory: Inventory




func load_inventory(_inventory: Inventory) -> void:

	inventory = _inventory

	_resize(inventory.size)

	for i in range(inventory.size):

		var item_data = inventory.item_list[i]

		var item_slot = get_child(i)

		item_slot.load_item_data(item_data)





func _resize(_size: int) -> void:

	clear()

	for i in range(_size):

		var slot = item_slot_scene.instantiate()

		slot.input_group_name = "player_inventory"

		slot.hover_input_received.connect(_on_slot_hover_input_received.bind(slot))

		slot.select_input_received.connect(_on_slot_select_input_received.bind(slot))

		add_child(slot)











func clear() -> void:

	for item_slot in get_children():

		item_slot.queue_free()









func _on_slot_hover_input_received(state: bool, slot: ItemSlot) -> void:

	slot.set_hover_state(state)



func _on_slot_select_input_received(slot: ItemSlot) -> void:

	if slot.selected:

		slot.set_select_state(false)

	else:

		if slot.input_group_name != &"":

			for item_slot in get_tree().get_nodes_in_group(slot.input_group_name):

				item_slot.set_select_state(false)

		slot.set_select_state(true)










func _activate() -> void:

	super()

	for child in get_children():

		child._activate()




func _deactivate() -> void:

	super()

	for child in get_children():

		child._deactivate()