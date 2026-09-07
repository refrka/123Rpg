class_name InteractableComponent extends Component


signal interaction_complete

@export var interaction_duration: float




func _start(interaction_source: EntityNode) -> void:

	entity.state_machine.request_state(BodyInteractingState)

	if !entity.entity_def.dialogue_library and !interaction_source.entity_def.dialogue_library:

		interaction_complete.emit()
	

func _end() -> void:

	entity.state_machine.request_state(BodyIdleState)


func _complete() -> void:

	pass


func _cancel() -> void:

	pass








func _get_duration() -> float:

	return interaction_duration