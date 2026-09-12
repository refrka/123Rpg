class_name BodyState extends State



var movement_component: MovementComponent






func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	super(_entity, _state_machine)

	movement_component = entity.get_component(MovementComponent)




func get_body_dir() -> Vector2:

	if movement_component:

		return movement_component.face_dir

	return Vector2.RIGHT