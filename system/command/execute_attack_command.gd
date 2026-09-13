class_name ExecuteAttackCommand extends Command


@export var buffer_index_chances: Array[float]


var combat_component: CombatComponent



func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	combat_component = _get_actor().get_component(CombatComponent)

	combat_component.buffered = false

	combat_component.attack_finished.connect(_on_attack_finished)

	if buffer_index_chances.size() - 1 >= combat_component.current_attack_index:

		if randf() < buffer_index_chances[combat_component.current_attack_index]:

			combat_component.buffered = true

	if combat_component._try_attack():

		_set_result(Result.PENDING)

	else:

		_set_result(Result.FAILURE)

	return result




func _cancel() -> void:

	combat_component.attack_finished.disconnect(_on_attack_finished)






func _on_attack_finished() -> void:

	if !combat_component.buffered:

		combat_component.attack_finished.disconnect(_on_attack_finished)

		_set_result(Result.SUCCESS)

		command_executed.emit()