class_name BodyBusyState extends BodyState








func _enter() -> void:

	super()

	var movement_component = entity.get_component(MovementComponent)

	if movement_component:

		movement_component.halt()


