class_name Disposition extends RefCounted



signal expired

signal attribute_updated(attribute: Global.Attribute, amount: float)


var attributes:= {

	Enums.Attribute.FEAR: 0.0,

	Enums.Attribute.AFFECTION: -0.5,

	Enums.Attribute.RESPECT: 0.0,

}






var target_entity: EntityNode

var expiration_timer:= 0.0

var timer_active:= false



var target_visible:= true

var last_known_position:= Vector2.INF




func update_attribute(attribute: Global.Attribute, amount: float) -> void:

	attributes[attribute] += amount

	attribute_updated.emit(attribute, amount)






static func create_new(_target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.new()

	disposition.target_entity = _target_entity

	return disposition