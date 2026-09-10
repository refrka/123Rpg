class_name ResourceComponent extends InteractableComponent









func _start(show_progress:= true) -> void:

	if show_progress:

		progress_bar.show()






func _end() -> void:

	progress_bar.hide()







func _complete() -> void:

	var apple_def = load("res://item/consumables/food/apple_def.tres")

	var apple_data = ItemData.create_new(apple_def, 33)

	var dir = Vector2(randf_range(-1.0, 1.0), randf_range(0.0, 1.0))

	var dist = randf_range(15.0, 30.0)

	var target_position = entity.global_position + (dir * dist)

	ItemNode.drop(apple_data, target_position)