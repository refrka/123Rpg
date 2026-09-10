class_name InteractWithEntityCommand extends Command



@export var duration:= -1.0

var target_interactable_component: InteractableComponent

var interaction_timer: SceneTreeTimer






func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var target_disposition = blackboard.get_value("target_disposition")

	if !target_disposition:

		_set_result(Result.FAILURE)

	else:

		var target_entity = target_disposition.target_entity

		if !target_entity or target_entity is Player:

			_set_result(Result.FAILURE)

			return result

		target_interactable_component = target_entity.get_interactable_component()

		if duration == -1.0:

			duration = target_interactable_component.interaction_duration

		var blackboard_duration = blackboard.get_value("duration", null)

		if blackboard_duration != null:

			duration = blackboard_duration

		if duration > 0.0:

			target_interactable_component._start(false)

			interaction_timer = Game.get_tree().create_timer(duration)

			interaction_timer.timeout.connect(_on_interaction_timeout)
		
			_set_result(Result.PENDING)

		else:

			target_interactable_component._complete()

			_set_result(Result.SUCCESS)

	return result









func _cancel() -> void:

	super()

	if interaction_timer:

		interaction_timer.timeout.disconnect(_on_interaction_timeout)

		target_interactable_component._cancel()
















func _on_interaction_timeout() -> void:

	interaction_timer = null

	target_interactable_component._complete()

	_set_result(Result.SUCCESS)

	command_executed.emit()