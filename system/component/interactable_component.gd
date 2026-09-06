class_name InteractableComponent extends Component


@warning_ignore("unused_signal")

signal interaction_complete


@export var progress_bar: ProgressBar






func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	if progress_bar:

		progress_bar.hide()





func _start_interacting() -> bool:

	entity.state_machine.request_state(BodyInteractingState)

	return true






func _end_interacting() -> bool:

	entity.state_machine.request_state(BodyIdleState)

	return true





func _complete_interacting() -> bool:

	return true






func _is_held_interaction() -> bool:

	return false





func _get_duration() -> float:

	return 0.0