class_name Behavior extends Resource



signal evaluation_requested



@export var display_name: String

@export var gate_conditions: Array[Condition]

@export var phases: Array[BehaviorPhase]

@export var baseline_score:= 0.5

var current_phase_index:= -1

var current_command_index:= 0

var current_phase_command: Command

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

	if current_phase_command:

		current_phase_command.command_executed.disconnect(_on_phase_command_executed)

		current_phase_command._cancel()









func _enter_phase(index: int) -> void:

	current_phase_index = index

	current_command_index = 0

	_execute_phase_command(0)


	





func _exit_phase() -> void:

	current_phase_index = 0

	current_command_index = 0









func _execute_phase_command(index: int) -> Command.Result:

	var phase = _get_phase(current_phase_index)

	current_phase_command = phase.phase_commands[index]

	current_phase_command.command_executed.connect(_on_phase_command_executed, CONNECT_ONE_SHOT)

	return current_phase_command._execute(blackboard)












func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 <= index:

		return phases[index]

	return null





func _get_behavior_multiplier() -> float:

	return 1.0



func _get_disposition_multiplier(disposition: Disposition) -> float:

	return 1.0







func _on_phase_command_executed() -> void:

	current_command_index += 1

	var phase = _get_phase(current_phase_index)

	if phase.phase_commands.size() - 1 < current_command_index:

		current_phase_command = null

		if phase.phase_transition_index != -1:

			_enter_phase(phase.phase_transition_index)

		evaluation_requested.emit()

		return

	_execute_phase_command(current_command_index)
