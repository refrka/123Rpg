class_name Behavior2 extends Resource




signal evaluation_requested





@export var display_name: String

@export var baseline_score:= 0.5

@export var phases: Array[BehaviorPhase]

@export var evaluation_thresholds: Array[AttributeThreshold]

@export var targeting_thresholds: Array[AttributeThreshold]

@export var gate_conditions: Array[Condition]



var blackboard: Blackboard

var current_phase_index: int

var current_command_index: int

var current_phase_command: Command

var current_target_disposition: Disposition









func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)







func _evaluate(target_disposition: Disposition = null) -> float:

	var attribute_multiplier = _get_attribute_multiplier()

	return baseline_score * attribute_multiplier




func _validate_current_target() -> void:

	for threshold in targeting_thresholds:

		var value = current_target_disposition.attributes[threshold.attribute]

		if threshold.value_meets_threshold(value):

			evaluation_requested.emit()

			return







func _start(target_disposition: Disposition = null) -> void:

	current_target_disposition = target_disposition

	_enter_phase(0)





func _stop() -> void:

	pass







func _enter_phase(index: int) -> void:

	var phase = _get_phase(index)

	if !phase:

		return

	current_phase_index = index

	_execute_phase_command(0)







func _exit_phase() -> void:

	if current_phase_command:

		current_phase_command._cancel()

		current_phase_command.command_executed.disconnect(_on_phase_command_executed)










func _execute_phase_command(index: int) -> void:

	var phase = _get_phase(current_phase_index)

	if phase.phase_commands.size() - 1 < index:

		return

	current_command_index = index

	current_phase_command = phase.phase_commands[index]

	match current_phase_command._execute(blackboard):
			
		Command.Result.PENDING:

			current_phase_command.command_executed.connect(_on_phase_command_executed, CONNECT_ONE_SHOT)












func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 >= index:

		return phases[index]

	return null




func _get_attribute_multiplier() -> float:

	return 1.0












func _on_phase_command_executed() -> void:

	current_phase_command = null