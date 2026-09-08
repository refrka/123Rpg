class_name ForcePlayerInteractionCommand extends Command






func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var player = Game.get_player()

	var player_interaction_component = player.get_component(InteractionComponent)

	player_interaction_component.interaction_ended.connect(_on_interaction_ended, CONNECT_ONE_SHOT)

	player_interaction_component.force_start_interaction(_get_actor())

	_set_result(Result.PENDING)

	return result






func _on_interaction_ended() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit()