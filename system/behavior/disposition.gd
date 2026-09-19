class_name Disposition extends RefCounted


@warning_ignore_start("unused_signal")

signal expired

signal attribute_updated(attribute: Enums.Attribute, amount: float)

signal visibility_updated(visible: bool)


var attributes:= {

	Enums.Attribute.FEAR: 0.0,

	Enums.Attribute.AFFECTION: 0.0,

	Enums.Attribute.RESPECT: 0.0,

}






var target_entity: EntityNode



var target_visible:= true

var last_known_position:= Vector2.INF





func set_visible_state(state: bool) -> void:

	target_visible = state

	visibility_updated.emit(state)




func update_attribute(attribute: Enums.Attribute, amount: float) -> void:

	attributes[attribute] += amount

	attribute_updated.emit(attribute, amount)





static func create_new(_target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.new()

	disposition.target_entity = _target_entity

	return disposition