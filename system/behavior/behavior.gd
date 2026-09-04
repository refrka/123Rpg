class_name Behavior extends Resource



signal phase_entered(phase: BehaviorPhase)

signal phase_command_started(command: Command)

signal phase_command_executed(command: Command)



@export var display_name: String

@export var gate_conditions: Array[Condition]

@export var phases: Array[BehaviorPhase]

@export var baseline_score:= 0.5

var current_phase_index:= -1

var blackboard:= Blackboard.new()







func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)







func get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 >= index:

		return phases[index]

	return null






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

	var phase = get_phase(current_phase_index)

	phase_entered.emit(phase)

	for command in phase.phase_commands:

		phase_command_started.emit(command)

		command.command_executed.connect(_on_command_executed, CONNECT_ONE_SHOT)

		var result = command._execute(blackboard)

		match result:

			Command.Result.SUCCESS:

				pass

			Command.Result.FAILURE:

				pass

			Command.Result.PENDING:

				if command.await_result:

					await command.command_executed

					continue

			Command.Result.CANCELLED:

				pass





func _exit_phase() -> void:

	pass







func _get_behavior_multiplier() -> float:

	return 1.0



func _get_disposition_multiplier(disposition: Disposition) -> float:

	return 1.0







func _on_command_executed(command: Command, result: Command.Result) -> void:

	phase_command_executed.emit(command, result)

	var phase = get_phase(current_phase_index)

	if phase.phase_command_transition_index != -1:

		_enter_phase(phase.phase_command_transition_index)