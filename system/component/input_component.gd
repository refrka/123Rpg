class_name InputComponent extends Component



signal interact_pressed

signal interact_released

signal profile_pressed



var input_dir: Vector2


var movement_component: MovementComponent






func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS







func _initialize(_entity: EntityNode) -> void:

	if initialized:

		return
	
	super(_entity)

	movement_component = entity.get_component(MovementComponent)










func _unhandled_input(event: InputEvent) -> void:

	if !active:

		return

	if event.is_action_pressed("interact"):

		interact_pressed.emit()

	if event.is_action_released("interact"):

		interact_released.emit()

	if event.is_action_pressed("profile"):

		profile_pressed.emit()






func _physics_process(_delta: float) -> void:

	if !active:

		return

	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_component.handle_input_dir(input_dir)