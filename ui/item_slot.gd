class_name ItemSlot extends UIElement


@export var count_label: Label

@export var item_texture: TextureRect

@export var input_element: InputElement

@export var selected_stylebox: StyleBoxFlat

var item_data: ItemData







func _ready() -> void:

	if input_element:

		input_element.hover_state_changed.connect(_on_hover_state_changed)

		input_element.select_input_received.connect(_on_select_input_received)







func set_data(_item_data: ItemData) -> void:

	item_data = _item_data

	item_data.item_data_updated.connect(_on_item_data_updated)

	_update_count_label()

	_update_texture()





func clear() -> void:

	if item_data.item_data_updated.is_connected(_on_item_data_updated):

		item_data.item_data_updated.disconnect(_on_item_data_updated)

	item_data = null






func is_empty() -> bool:

	if !item_data:

		return true

	return item_data.is_empty()


















func handle_mouse_input(button_index: int, pressed: bool) -> void:

	var mouse_slot = UI.get_overlay(MouseSlotOverlay)

	if pressed:

		match [button_index, mouse_slot.item_slot.is_empty(), item_data.is_empty()]:

			[1, true, false]: # Left click, nothing held, slot has data
				
				mouse_slot.hold_slot(self)

			[1, false, false]: # Left click, data held, slot has data

				if mouse_slot.origin_slot == self:

					mouse_slot.drop_slot()

				elif item_data.can_accept(mouse_slot.item_slot.item_data.item_def):

					item_data.add_data(mouse_slot.item_slot.item_data)

					if mouse_slot.item_slot.is_empty():

						mouse_slot.drop_slot()

			[1, false, true]: # Left click, data held, slot is empty

				item_data.add_data(mouse_slot.item_slot.item_data)

				mouse_slot.drop_slot()


















func _update_count_label() -> void:

	if !item_data or item_data.is_empty():

		count_label.text = ""

	else:

		count_label.text = str(item_data.count)




func _update_texture() -> void:

	if !item_data or item_data.is_empty():

		item_texture.texture = null

	else:

		item_texture.texture = item_data.item_def.body_sprite_texture









func _on_item_data_updated() -> void:

	_update_count_label()

	_update_texture()




func _on_hover_state_changed(state: bool) -> void:

	pass



func _on_select_input_received(button_index: int, pressed: bool) -> void:

	handle_mouse_input(button_index, pressed)