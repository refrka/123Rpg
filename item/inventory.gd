class_name Inventory extends Resource




@export var item_list: Array[ItemData]

@export var size:= 9






func initialize() -> void:

	_resize(size)






func _resize(new_size: int) -> void:

	size = new_size

	while item_list.size() > new_size:

		item_list.pop_back()

	while item_list.size() < new_size:

		item_list.append(ItemData.new())






func _get_item_data_with_def(item_def: ItemDef) -> Array[ItemData]:

	var data_list: Array[ItemData] = []

	for item_data in item_list:

		if item_data.item_def == item_def and item_data.count > 0:

			data_list.append(item_data)

	return data_list




func _get_empty_data() -> ItemData:

	for item_data in item_list:

		if item_data.is_empty():

			return item_data

	return null







func add_item_data(item_data: ItemData) -> void:

	var data_list = _get_item_data_with_def(item_data.item_def)

	for _item_data in data_list:

		_item_data.absorb(item_data)

		if item_data.is_empty():

			break
	
	var _item_data = _get_empty_data()

	if _item_data:

		_item_data.assign_data(item_data)