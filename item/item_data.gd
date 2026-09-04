class_name ItemData extends Resource


signal item_data_updated



@export var item_def: ItemDef

@export var count: int




func set_data(_item_def: ItemDef, _count:= 1) -> void:

	item_def = _item_def

	count = _count

	if count == 0:

		item_def = null

	item_data_updated.emit()






func add_amount(_item_def: ItemDef, amount: int) -> int:

	var remaining = amount

	var new_count = count

	var space = _item_def.max_stack - count

	if space >= remaining:

		new_count += remaining

		remaining = 0

	else:

		new_count = _item_def.max_stack

		remaining -= space

	set_data(_item_def, new_count)

	return remaining




func remove_amount(amount: int) -> int:

	var remaining = amount

	var new_count = count

	if count >= remaining:

		new_count -= remaining

		remaining = 0

	else:

		new_count = 0

		remaining -= count

	set_data(item_def, new_count)

	return remaining

		





func is_empty() -> bool:

	return !item_def or count == 0




func is_full() -> bool:

	if is_empty():

		return false

	return count == item_def.max_stack