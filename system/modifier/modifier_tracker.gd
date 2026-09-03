class_name ModifierTracker extends Resource





var modifiers: Array[Modifier]



func add_modifier(modifier: Modifier) -> void:

	modifiers.append(modifier)

	modifier.expired.connect(_on_modifier_expired.bind(modifier))





func remove_modifier(modifier: Modifier) -> void:

	modifiers.erase(modifier)






func get_total_float_value() -> float:

	var total:= 0.0

	for modifier in modifiers:

		total += modifier.value

	return total



func get_total_vector_value() -> Vector2:

	var total:= Vector2.ZERO

	for modifier in modifiers:

		total += modifier.value

	return total




func get_total_multiplier_value() -> float:

	var total:= 1.0

	for modifier in modifiers:

		total *= modifier.value

	return total



func tick_modifiers(delta: float) -> void:

	for modifier in modifiers:

		modifier._tick(delta)





func _on_modifier_expired(modifier: Modifier) -> void:

	modifiers.erase(modifier)