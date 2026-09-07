class_name InteractableComponent extends Component








func _start() -> void:

	entity.state_machine.request_state(BodyInteractingState)
	

func _end() -> void:

	entity.state_machine.request_state(BodyIdleState)


func _complete() -> void:

	pass


func _cancel() -> void:

	pass








func _get_duration() -> float:

	return 0.0