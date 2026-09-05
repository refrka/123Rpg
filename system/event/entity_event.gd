class_name EntityEvent extends Event



var entity: EntityNode




func fire(_blackboard: Blackboard) -> void:

	super(_blackboard)

	entity = blackboard.get_value("entity")