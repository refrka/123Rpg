class_name Behavior extends Resource





@export var phases: Array[BehaviorPhase]




var blackboard:= Blackboard.new()

var current_phase: BehaviorPhase

var current_command_index:= 0

var current_command: Command

var pending_commands: Array[Command]









func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)






func _evaluate(target_disposition: Disposition = null) -> float:

	return 1.0







func _start() -> void:

	_enter_phase(0)




func _stop() -> void:

	pass






func _enter_phase(index: int) -> void:

	if current_phase:

		_exit_phase()

	pending_commands.clear()

	current_command_index = 0

	current_phase = _get_phase(index)

	if !current_phase:

		return

	_execute_phase_command(0)





func _exit_phase() -> void:

	pass





func _execute_phase_command(index: int) -> void:

	if current_phase.phase_commands.size() - 1 < index:

		if pending_commands.is_empty() and current_phase.phase_command_transition_index != -1:

			_enter_phase(current_phase.phase_command_transition_index)

		return

	current_command = current_phase.phase_commands[index]

	current_command.command_executed.connect(_on_phase_command_executed)

	if current_command._execute(blackboard) == Command.Result.PENDING:
	
		pending_commands.append(current_command)

	if !current_command.await_result:

		current_command_index += 1

		_execute_phase_command(current_command_index)





func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 >= index:

		return phases[index]
	
	return null









func _on_phase_command_executed(command: Command, result: Command.Result) -> void:

	command.command_executed.disconnect(_on_phase_command_executed)

	pending_commands.erase(command)

	match result:

		Command.Result.SUCCESS:

			current_command_index += 1

			if current_phase.phase_commands.size() - 1 < current_command_index and current_phase.phase_command_transition_index != -1 and pending_commands.is_empty():

				_enter_phase(current_phase.phase_command_transition_index)

			else:

				_execute_phase_command(current_command_index)

