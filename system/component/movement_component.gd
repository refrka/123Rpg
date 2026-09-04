class_name MovementComponent extends Component



signal move_started

signal move_ended



var move_dir: Vector2

var face_dir: Vector2




var current_move_velocity: Vector2







func handle_input_dir(dir: Vector2) -> void:

	set_move_dir(dir)




func halt() -> void:

	set_move_dir(Vector2.ZERO)

	current_move_velocity = Vector2.ZERO




func set_move_dir(dir: Vector2) -> void:

	if dir != move_dir:

		move_dir = dir

		if dir != Vector2.ZERO:

			set_face_dir(dir)




func set_face_dir(dir: Vector2) -> void:

	if dir != face_dir:

		face_dir = dir







func _physics_process(delta: float) -> void:

	if !active:

		return

	var move_velocity = current_move_velocity

	if move_dir == Vector2.ZERO:

		move_velocity = move_velocity.move_toward(Vector2.ZERO, 2000.0 * delta)

	else:

		move_velocity = move_velocity.move_toward(move_dir * entity.entity_def.move_speed, 2000.0 * delta)

	if move_velocity == Vector2.ZERO and current_move_velocity != Vector2.ZERO:

		move_ended.emit()

	if move_velocity != Vector2.ZERO and current_move_velocity == Vector2.ZERO:

		move_started.emit()

	entity.velocity = move_velocity

	current_move_velocity = move_velocity

	entity.move_and_slide()