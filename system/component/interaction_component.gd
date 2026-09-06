class_name InteractionComponent extends Component






var target_interactable_entity: EntityNode

var target_interactable_component: InteractableComponent





func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.interact_pressed.connect(_on_interact_pressed)

		input_component.interact_released.connect(_on_interact_released)






func _try_interact() -> void:

	if entity.interaction_sensor.entities.is_empty():

		return

	var nearest_entity = entity.interaction_sensor.get_nearest_entity()

	_set_target_interactable(nearest_entity)

	_start_interaction()





func _try_end_interaction() -> void:

	if target_interactable_component._end_interacting():

		_end_interaction()






func _start_interaction() -> void:

	if target_interactable_component._start_interacting(): 

		target_interactable_component.interaction_complete.connect(_complete_interaction)

		entity.state_machine.request_state(BodyInteractingState)





func _end_interaction() -> void:

	entity.state_machine.request_state(BodyIdleState)

	target_interactable_component._end_interacting()

	target_interactable_component.interaction_complete.disconnect(_complete_interaction)




func _complete_interaction() -> void:

	_end_interaction()





func _is_interacting() -> bool:

	return entity.state_machine.current_body_state is BodyInteractingState






func _set_target_interactable(target_entity: EntityNode) -> void:

	target_interactable_entity = target_entity

	target_interactable_component = target_entity.get_interactable_component()







func _on_interact_pressed() -> void:

	if _is_interacting():

		_try_end_interaction()

	else:

		_try_interact()






func _on_interact_released() -> void:

	if _is_interacting() and target_interactable_component._is_held_interaction():

		_try_end_interaction()