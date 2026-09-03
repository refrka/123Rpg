class_name InputComponent extends Component





var input_dir: Vector2


var movement_component: MovementComponent






func _initialize(_entity: EntityNode) -> void:
	
	super(_entity)

	movement_component = entity.get_component(MovementComponent)
















func _physics_process(_delta: float) -> void:

	if !active:

		return

	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_component.handle_input_dir(input_dir)