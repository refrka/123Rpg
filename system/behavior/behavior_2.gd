class_name Behavior2 extends Resource




signal evaluation_requested

signal last_command_executed



enum BehaviorType {

	COMBAT,

	PRESERVATION,

	AMBIENT,

	SOCIAL,

}




@export var display_name: String

@export var behavior_type: BehaviorType

@export var allowed_type_transitions:= [

	BehaviorType.COMBAT,

	BehaviorType.PRESERVATION,

	BehaviorType.AMBIENT,
	
	BehaviorType.SOCIAL,

]

@export var baseline_score:= 0.5

@export var phases: Array[BehaviorPhase]

@export var evaluation_thresholds: Array[AttributeThreshold]

@export var targeting_thresholds: Array[AttributeThreshold]

@export var gate_conditions: Array[Condition]

@export var attribute_map: AttributeMap




var active:= false

var blackboard:= Blackboard.new()

var current_phase_index: int

var current_command_index: int

var current_phase_command: Command

var current_target_disposition: Disposition



var end_on_current_command_executed:= false







func _initialize(entity: EntityNode) -> void:

	blackboard.set_value("actor", entity)







func _evaluate(target_disposition: Disposition = null) -> float:

	blackboard.set_value("target_disposition", target_disposition)

	for condition in gate_conditions:

		if !condition._evaluate(blackboard):

			return 0.0

	if !targeting_thresholds.is_empty() and target_disposition == null:

		return 0.0

	if behavior_type == BehaviorType.COMBAT or behavior_type == BehaviorType.SOCIAL:

		if target_disposition and !target_disposition.target_visible:

			return 0.0

	var attribute_multiplier = 1.0

	if target_disposition and target_disposition.target_visible:

		attribute_multiplier = _get_attribute_multiplier(target_disposition)

	print("FUCK YOU", display_name, attribute_multiplier)

	return baseline_score * attribute_multiplier






func _validate_current_target() -> void:

	if behavior_type == BehaviorType.COMBAT or behavior_type == BehaviorType.SOCIAL:

		if !current_target_disposition.target_visible:

			evaluation_requested.emit()

			return

	for threshold in targeting_thresholds:

		var value = current_target_disposition.attributes[threshold.attribute]

		if threshold.value_meets_threshold(value):

			evaluation_requested.emit()

			return







func _start(target_disposition: Disposition = null) -> void:

	active = true

	blackboard.set_value("target_disposition", target_disposition)

	current_target_disposition = target_disposition

	_enter_phase(0)





func _stop() -> void:

	active = false

	_exit_phase()

	current_target_disposition = null








func _enter_phase(index: int) -> void:

	var phase = _get_phase(index)

	if !phase:

		return

	current_phase_index = index

	_execute_phase_command(0)







func _exit_phase() -> void:

	if current_phase_command:

		current_phase_command.command_executed.disconnect(_on_phase_command_executed)

		current_phase_command._cancel()










func _execute_phase_command(index: int) -> void:

	var phase = _get_phase(current_phase_index)

	if phase.phase_commands.size() - 1 < index:

		return

	current_command_index = index

	current_phase_command = phase.phase_commands[index]

	if current_phase_command.command_executed.is_connected(_on_phase_command_executed):

		print("already connected in behavior %s: " % display_name, current_phase_command)

	current_phase_command.command_executed.connect(_on_phase_command_executed, CONNECT_ONE_SHOT)

	current_phase_command._execute(blackboard)












func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 >= index:

		return phases[index]

	return null






func _get_attribute_multiplier(target_disposition: Disposition = null) -> float:

	var multiplier:= 1.0

	if !target_disposition:

		target_disposition = current_target_disposition

	if target_disposition:

		var fear_mult = attribute_map.get_value(Enums.Attribute.FEAR, target_disposition.attributes[Enums.Attribute.FEAR])

		var affection_mult = attribute_map.get_value(Enums.Attribute.AFFECTION, target_disposition.attributes[Enums.Attribute.AFFECTION])

		var respect_mult = attribute_map.get_value(Enums.Attribute.RESPECT, target_disposition.attributes[Enums.Attribute.RESPECT])

		multiplier *= fear_mult * affection_mult * respect_mult

	return multiplier











func _on_phase_command_executed() -> void:

	current_phase_command = null

	var next_index = current_command_index + 1

	var phase = _get_phase(current_phase_index)

	if phase.phase_commands.size() - 1 >= next_index:

		_execute_phase_command(next_index)

	else:
		
		last_command_executed.emit()

		if phase.phase_transition_index != -1:

			_enter_phase(phase.phase_transition_index)

		