class_name MoveToPositionCommand extends Command




@export var target_position: Vector2




func _execute(_blackboard: Blackboard) -> Result:

	super(_blackboard)

	var blackboard_position = blackboard.get_value("target_position", null)

	if blackboard_position != null:

		target_position = blackboard_position

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.navigation_finished.connect(_on_navigation_finished)

	navigation_component.set_target_position(target_position)

	return Result.PENDING






func _cancel() -> void:

	var navigation_component = _get_actor().get_component(NavigationComponent)

	navigation_component.stop()






func _on_navigation_finished() -> void:

	command_executed.emit(Result.SUCCESS)