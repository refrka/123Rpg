class_name Inventory extends Resource




@export var item_list: Array[ItemData]

@export var size:= 9

@export var weapon_data: EquipmentData






func initialize() -> void:

	_resize()






func add_item_def(item_def: ItemDef, amount:= 1) -> int:

	var remaining = amount

	var item_data = _get_data_with(item_def)

	if !item_data:

		item_data = _get_empty_data()

	if item_data:

		remaining = item_data.add_amount(item_def, amount)

	return remaining








func _get_data_with(item_def: ItemDef) -> ItemData:

	for i in range(size - 1, -1, -1):

		var item_data = item_list[i]

		if item_data.item_def == item_def:

			return item_data

	return null





func _get_empty_data() -> ItemData:

	for item_data in item_list:

		if item_data.is_empty():

			return item_data

	return null









func _resize() -> void:

	while item_list.size() > size:

		item_list.pop_back()

	while item_list.size() < size:

		item_list.append(ItemData.new())



