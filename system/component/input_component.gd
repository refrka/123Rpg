class_name InputComponent extends Component


signal attack_pressed

signal attack_released




var input_dir: Vector2


var movement_component: MovementComponent






func _initialize(_entity: EntityNode) -> void:

	if initialized:

		return
	
	super(_entity)

	movement_component = entity.get_component(MovementComponent)











func _unhandled_input(event: InputEvent) -> void:

	if !active:

		return

	if event.is_action_pressed("attack"):

		attack_pressed.emit()

	if event.is_action_released("attack"):

		attack_released.emit()









func _physics_process(_delta: float) -> void:

	if !active:

		return

	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_component.handle_input_dir(input_dir)