class_name InteractionComponent extends Component


signal interaction_completed



var target_interactable_entity: EntityNode

var target_interactable_component: InteractableComponent





func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.interact_pressed.connect(_on_interact_pressed)

		input_component.interact_released.connect(_on_interact_released)






func _try_interact(target_entity: EntityNode = null) -> bool:

	if entity.interaction_sensor.entities.is_empty():

		return false

	if target_entity:

		if !entity.interaction_sensor.entities.has(target_entity):

			return false

	else:
		
		target_entity = entity.interaction_sensor.get_nearest_entity()

	_set_target_interactable(target_entity)

	_start_interaction()

	return true




func _try_end_interaction() -> void:

	if target_interactable_component._end_interacting():

		_end_interaction()






func _start_interaction() -> void:

	if target_interactable_component._start_interacting(): 

		print("started interaction with ", target_interactable_component)

		target_interactable_component.interaction_complete.connect(_complete_interaction)

		print("connected")

		entity.state_machine.request_state(BodyInteractingState)

		if entity is Player:

			target_interactable_component._load_ui()





func _end_interaction() -> void:

	entity.state_machine.request_state(BodyIdleState)

	target_interactable_component._end_interacting()

	target_interactable_component.interaction_complete.disconnect(_complete_interaction)

	if entity is Player:

		target_interactable_component._unload_ui()




func _complete_interaction() -> void:

	target_interactable_component._complete_interacting()

	_end_interaction()

	interaction_completed.emit()





func _is_interacting() -> bool:

	return entity.state_machine.current_body_state is BodyInteractingState






func _set_target_interactable(target_entity: EntityNode) -> void:

	target_interactable_entity = target_entity

	target_interactable_component = target_entity.get_interactable_component()







func _on_interact_pressed() -> void:

	if _is_interacting() and target_interactable_component:

		_try_end_interaction()

	else:

		_try_interact()






func _on_interact_released() -> void:

	if _is_interacting() and target_interactable_component._is_held_interaction():

		_try_end_interaction()