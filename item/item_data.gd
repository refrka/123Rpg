class_name ItemData extends Resource


signal item_data_updated


@export var item_def: ItemDef

@export var count:= 0





func assign_data(item_data: ItemData) -> void:

	set_data(item_data.item_def, item_data.count)

	item_data.set_data(null, 0)





func set_data(_item_def: ItemDef, _count: int) -> void:

	item_def = _item_def

	count = _count

	item_data_updated.emit()




func add_data(item_data: ItemData) -> void:

	if is_empty():

		assign_data(item_data)

	else:

		absorb(item_data)




func add_amount(amount: int) -> int:

	var remaining = amount

	var new_count = count

	var space = item_def.max_stack - count

	if space >= remaining:

		new_count += remaining

		remaining = 0

	else:

		new_count = item_def.max_stack

		remaining -= space

	set_data(item_def, new_count)

	return remaining






func remove_amount(amount: int) -> int:

	var remaining = amount

	var new_count = count

	if remaining <= amount:

		new_count -= remaining

		remaining = 0

	else:

		new_count = 0

		remaining -= count

	set_data(item_def, new_count)

	return remaining






func absorb(item_data: ItemData) -> void:

	var remaining = add_amount(item_data.count)

	item_data.set_data(item_def, remaining)




func can_accept(_item_def: ItemDef) -> bool:

	if is_empty() or item_def == _item_def:

		return true

	return false






func is_empty() -> bool:

	return !item_def or count <= 0





static func create_new(_item_def: ItemDef, _count: int) -> ItemData:

	var item_data = ItemData.new()

	item_data.set_data(_item_def, _count)

	return item_data