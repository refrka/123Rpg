class_name Disposition extends RefCounted



signal attribute_updated(attribute: Behavior.Attribute, new_value: float)




var target_entity: EntityNode

var attribute_values:= {

	Behavior.Attribute.FEAR: 0.0,

	Behavior.Attribute.AFFECTION: 0.0,

	Behavior.Attribute.RESPECT: 0.0,

}





func get_attribute_value(attribute: Behavior.Attribute) -> float:

	return attribute_values[attribute]




func update_attribute_value(attribute: Behavior.Attribute, amount: float) -> void:

	var current_value = get_attribute_value(attribute)

	var new_value = current_value + amount

	attribute_values.set(attribute, new_value)

	attribute_updated.emit(attribute, new_value)




func add_baseline(attribute_baseline: AttributeBaseline) -> void:

	update_attribute_value(Behavior.Attribute.FEAR, attribute_baseline.get_value(Behavior.Attribute.FEAR))

	update_attribute_value(Behavior.Attribute.AFFECTION, attribute_baseline.get_value(Behavior.Attribute.AFFECTION))

	update_attribute_value(Behavior.Attribute.RESPECT, attribute_baseline.get_value(Behavior.Attribute.RESPECT))