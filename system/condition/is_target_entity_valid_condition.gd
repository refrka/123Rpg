class_name IsTargetEntityValidCondition extends Condition




@export var entity_def_whitelist: Array[EntityDef]

@export var entity_def_blacklist: Array[EntityDef]





func _evaluate(_blackboard: Blackboard) -> bool:

	super(_blackboard)

	var target_entity = blackboard.get_value("target_entity")

	if !target_entity:

		return FAIL

	if !entity_def_whitelist.is_empty() and !entity_def_whitelist.has(target_entity.entity_def):

		return FAIL

	if !entity_def_blacklist.is_empty() and entity_def_blacklist.has(target_entity.entity_def):

		return FAIL

	return PASS