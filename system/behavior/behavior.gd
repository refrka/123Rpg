class_name Behavior extends Resource


enum BehaviorType {

	COMBAT,

	PRESERVATION,

	AMBIENT,

	SOCIAL,

}

signal evaluation_requested


var active:= false



@export var display_name: String

@export var behavior_type: BehaviorType

@export var allowed_type_transitions: Array[BehaviorType] = [

	BehaviorType.COMBAT,

	BehaviorType.PRESERVATION,

	BehaviorType.AMBIENT,

	BehaviorType.SOCIAL,

]

@export var evaluation_thresholds: Array[AttributeThreshold]

@export var prefer_current_target:= false

@export var gate_conditions: Array[Condition]

@export var retarget_conditions: Array[Condition]

@export var phases: Array[BehaviorPhase]

@export var baseline_score:= 0.5

@export var requires_disposition:= false

var current_phase_index:= -1

var current_command_index:= 0

var current_phase_command: Command

var current_target_disposition: Disposition

var blackboard:= Blackboard.new()







func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)









func _evaluate(target_disposition: Disposition = null) -> float:

	var behavior_multiplier = _get_behavior_multiplier()

	var disposition_multiplier = _get_disposition_multiplier(target_disposition)

	if target_disposition == current_target_disposition and prefer_current_target:

		disposition_multiplier *= 1.5

	if current_target_disposition and target_disposition:

		blackboard.set_value("target_entity", target_disposition.target_entity)

		var passed:= true

		for condition in retarget_conditions:

			if !condition._evaluate(blackboard):

				passed = false

		if passed:

			current_target_disposition = target_disposition

	if target_disposition:

		blackboard.set_value("target_entity", target_disposition.target_entity)

	for condition in gate_conditions:

		if !condition._evaluate(blackboard):

			return 0.0

	return baseline_score * behavior_multiplier * disposition_multiplier












func _start() -> void:

	active = true

	_enter_phase(0)




func _stop() -> void:

	active = false

	if current_phase_command:

		current_phase_command.command_executed.disconnect(_on_phase_command_executed)

		current_phase_command._cancel()





func _change_target_disposition(new_target_disposition: Disposition) -> void:

	current_target_disposition = new_target_disposition

	blackboard.set_value("target_disposition", new_target_disposition)

	if active:

		_start()






func _enter_phase(index: int) -> void:

	current_phase_index = index

	current_command_index = 0

	_execute_phase_command(0)


	





func _exit_phase() -> void:

	current_phase_index = 0

	current_command_index = 0

	if current_phase_command and current_phase_command.command_executed.is_connected(_on_phase_command_executed):

		current_phase_command.command_executed.disconnect(_on_phase_command_executed)









func _execute_phase_command(index: int) -> Command.Result:

	var phase = _get_phase(current_phase_index)

	current_phase_command = phase.phase_commands[index]

	current_phase_command.command_executed.connect(_on_phase_command_executed, CONNECT_ONE_SHOT)

	return current_phase_command._execute(blackboard)












func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 >= index:

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

			return

		evaluation_requested.emit()

		return

	_execute_phase_command(current_command_index)
