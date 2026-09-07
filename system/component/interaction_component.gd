class_name InteractionComponent extends Component




var current_interaction: Interaction









func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.interact_pressed.connect(_on_interact_pressed)

		input_component.interact_released.connect(_on_interact_released)






func get_interaction_status() -> Interaction.Status:

	if current_interaction:

		return current_interaction.status

	return Interaction.Status.INACTIVE






func _can_interact(target_entity: EntityNode) -> bool:

	var interactable_component = target_entity.get_interactable_component()

	if !interactable_component:

		return false

	return true





func _start_interaction(target_entity: EntityNode) -> void:

	if current_interaction:

		_end_interaction()

	current_interaction = Interaction.start_new(entity, target_entity)

	






func _end_interaction() -> void:

	match current_interaction.status:

		Interaction.Status.PENDING:

			current_interaction.set_status(Interaction.Status.CANCELLED)


















func _on_interact_pressed() -> void:

	pass



func _on_interact_released() -> void:

	pass












func _physics_process(delta: float) -> void:

	if !active:

		return

	if get_interaction_status() == Interaction.Status.PENDING:

		current_interaction.tick(delta)