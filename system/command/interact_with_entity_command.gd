class_name InteractWithEntityCommand extends Command



@export var interaction_duration_range:= Vector2(3.0, 3.0)


var interaction_component: InteractionComponent

var target_entity: EntityNode

var interact_timer: SceneTreeTimer



func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	interaction_component = _get_actor().get_component(InteractionComponent)

	interaction_component.interaction_completed.connect(_on_interaction_completed, CONNECT_ONE_SHOT)

	target_entity = blackboard.get_value("target_entity", null)

	if !target_entity:

		target_entity = _get_actor().interaction_sensor.get_nearest_entity()

	if interaction_component._try_interact(target_entity):

		var duration = randf_range(interaction_duration_range.x, interaction_duration_range.y)

		interact_timer = Game.get_tree().create_timer(duration)

		interact_timer.timeout.connect(_on_interaction_timeout)

		_set_result(Result.PENDING)

	else:

		_set_result(Result.FAILURE)

	return result




func _complete_interaction() -> void:

	interaction_component._complete_interaction()



 
func _cancel() -> void:

	if interact_timer:

		interact_timer.timeout.disconnect(_on_interaction_timeout)

	super()






func _on_interaction_timeout() -> void:

	_complete_interaction()

	_set_result(Result.SUCCESS)
	
	command_executed.emit(self, result)



func _on_interaction_completed() -> void:

	_set_result(Result.SUCCESS)

	command_executed.emit(self, result)

	if interact_timer:

		interact_timer.timeout.disconnect(_on_interaction_timeout)