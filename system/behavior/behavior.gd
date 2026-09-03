class_name Behavior extends Resource



@export var display_name: String

@export var gate_conditions: Array[Condition]

@export var phases: Array[BehaviorPhase]

@export var baseline_score:= 0.5

var current_phase_index:= -1

var blackboard:= Blackboard.new()







func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)









func _evaluate(target_disposition: Disposition = null) -> float:

	blackboard.set_value("target_disposition", target_disposition)

	for condition in gate_conditions:

		if !condition._evaluate(blackboard):

			return 0.0

	var behavior_multiplier = _get_behavior_multiplier()

	var disposition_multiplier = _get_disposition_multiplier(target_disposition)

	return baseline_score * behavior_multiplier * disposition_multiplier








func _start() -> void:

	_enter_phase(0)




func _stop() -> void:

	pass









func _enter_phase(index: int) -> void:

	current_phase_index = index

	var phase = _get_phase(current_phase_index)

	for command in phase.phase_commands:

		command.command_executed.connect(_on_command_executed, CONNECT_ONE_SHOT)

		match command._execute(blackboard):

			Command.Result.SUCCESS:

				pass

			Command.Result.FAILURE:

				pass

			Command.Result.PENDING:

				pass

				if command.await_result:

					await command.command_executed

					continue

			Command.Result.CANCELLED:

				pass





func _exit_phase() -> void:

	pass






func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 <= index:

		return phases[index]

	return null





func _get_behavior_multiplier() -> float:

	return 1.0



func _get_disposition_multiplier(disposition: Disposition) -> float:

	return 1.0







func _on_command_executed(result: Command.Result) -> void:

	pass