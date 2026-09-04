class_name NavigationComponent extends Component


signal navigation_finished


@export var nav_agent: NavigationAgent2D


var update_timer:= 0.0


var current_target_position: Vector2

var current_target_entity: EntityNode

var movement_component: MovementComponent



func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	movement_component = entity.get_component(MovementComponent)







func _connect_signals() -> void:

	nav_agent.navigation_finished.connect(_on_navigation_finished)



func _disconnect_signals() -> void:

	nav_agent.navigation_finished.disconnect(_on_navigation_finished)




func set_target_position(target_position: Vector2) -> void:

	current_target_position = target_position

	nav_agent.target_position = target_position





func set_target_entity(target_entity: EntityNode) -> void:

	current_target_entity = target_entity

	if target_entity:

		nav_agent.target_position = target_entity.global_position

		update_timer = 0.2

	else:

		update_timer = 0.0





func stop() -> void:

	movement_component.halt()

	set_target_entity(null)







func _on_navigation_finished() -> void:

	movement_component.halt()

	navigation_finished.emit()








func _physics_process(delta: float) -> void:

	if current_target_entity and update_timer > 0.0:

		update_timer -= delta

		if update_timer <= 0.0:

			set_target_position(current_target_entity.global_position)

			update_timer = 0.15

	if !nav_agent.is_navigation_finished():

		var next_position = nav_agent.get_next_path_position()

		var dir = entity.global_position.direction_to(next_position)

		movement_component.set_move_dir(dir)

		