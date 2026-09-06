class_name ItemSlot extends InputUIElement


@export var slot_texture: TextureRect

@export var slot_count_label: Label


var item_data: ItemData



func load_item_data(_item_data: ItemData) -> void:

	item_data = _item_data

	_update_slot()






func _update_slot() -> void:

	if item_data == null or item_data.is_empty():

		slot_count_label.text = ""

		slot_texture.texture = null

	else:

		slot_count_label.text = str(item_data.count)

		slot_texture.texture = item_data.item_def.item_texture









func _on_item_data_updated() -> void:

	_update_slot()







func _activate() -> void:

	super()

	item_data.item_data_updated.connect(_on_item_data_updated)




func _deactivate() -> void:

	super()

	item_data.item_data_updated.disconnect(_on_item_data_updated)