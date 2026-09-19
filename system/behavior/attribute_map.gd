class_name AttributeMap extends Resource



@export var curves: Dictionary[Enums.Attribute, Curve]




func get_value(attribute: Enums.Attribute, offset: float) -> float:

	if curves.has(attribute):

		return curves[attribute].sample(offset)

	return 1.0