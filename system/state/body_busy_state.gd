class_name BodyBusyState extends BodyState








func _enter() -> void:

	super()

	if movement_component:

		movement_component.halt()


