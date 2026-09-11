class_name MovementComponent extends Component



signal move_started

signal move_ended





var modifier_tracker:= ModifierTracker.new()


var move_dir: Vector2


var current_move_velocity: Vector2







func handle_input_dir(dir: Vector2) -> void:

	set_move_dir(dir)




func halt() -> void:

	set_move_dir(Vector2.ZERO)

	current_move_velocity = Vector2.ZERO




func set_move_dir(dir: Vector2) -> void:

	if dir != move_dir:

		move_dir = dir




func get_move_speed() -> float:

	var base_speed = entity.entity_def.move_speed

	var modifier_multiplier = modifier_tracker.get_total_multiplier_value()

	return base_speed * modifier_multiplier






func _physics_process(delta: float) -> void:

	if !active or entity.is_busy():

		return

	var move_velocity = current_move_velocity

	if move_dir == Vector2.ZERO:

		move_velocity = move_velocity.move_toward(Vector2.ZERO, 2000.0 * delta)

	else:

		move_velocity = move_velocity.move_toward(move_dir * get_move_speed(), 2000.0 * delta)

	if move_velocity == Vector2.ZERO and current_move_velocity != Vector2.ZERO:

		move_ended.emit()

	if move_velocity != Vector2.ZERO and current_move_velocity == Vector2.ZERO:

		move_started.emit()

	entity.velocity = move_velocity

	current_move_velocity = move_velocity

	entity.move_and_slide()