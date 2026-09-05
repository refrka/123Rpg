class_name AttackCommand extends Command








func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var combat_component = _get_actor().get_component(CombatComponent)

	combat_component.attack_ended.connect(_on_attack_ended, CONNECT_ONE_SHOT)

	combat_component._try_attack()

	_set_result(Result.PENDING)

	return result












func _on_attack_ended() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit(self, result)