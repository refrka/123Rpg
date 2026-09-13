class_name AttributeThreshold extends Resource



@export var use_delta:= false

@export var attribute: Enums.Attribute

@export_enum("less than", "less than or equal", "greater than", "greater than or equal") var comparator: String

@export var value: float




func value_meets_threshold(compared_value: float) -> bool:

	match comparator:

		"less than":

			return compared_value < value

		"less than or equal":

			return compared_value <= value

		"greater than":

			return compared_value > value

		"greater than or equal":

			return compared_value >= value

	return false