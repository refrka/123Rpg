class_name Behavior extends Resource




@export var phases: Array[BehaviorPhase]

var current_phase_index:= -1

var last_evaluated_disposition: Disposition






func _evaluate(disposition: Disposition = null) -> float:

	if disposition:

		last_evaluated_disposition = disposition

	return 1.0








func _start() -> void:

	pass




func _stop() -> void:

	pass









func _enter_phase(phase: BehaviorPhase) -> void:

	pass




func _exit_phase() -> void:

	pass






func _get_phase(index: int) -> BehaviorPhase:

	if phases.size() - 1 <= index:

		return phases[index]

	return null