class_name AttributeBaseline extends Resource


@export var baseline_values:= {

	"ATTITUDE": 0.0,

	"TEMPERAMENT": 0.0,

	"FEAR": 0.0,

	"AFFECTION": 0.0,

	"RESPECT": 0.0,

}


func get_value(attribute: Behavior.Attribute) -> float:

	var attribute_name = Behavior.Attribute.keys()[attribute]

	return baseline_values[attribute_name]

		