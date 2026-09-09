class_name InteractionComponent extends Component


signal interaction_started

signal interaction_ended


# ==========================================
#
# Dialogue Interactions
#	- Dialogue can be initiated by the player or force-started by an entity
#	- The target Interactable is in charge of activating/deactivating dialogue UI
#		- Force-start: A ForceStartDialogueCommand accesses the player's InteractionComponent
#		and calls force_start_interaction() with the entity referece as argument.
#
# Ending interactions
#	- The Interactable can end the interaction with an end_requested signal
#		- When DialogueOverlay is closed, overlay_closed signal is heard and end_requested is emitted
#			- InteractionOverlay? The overlay needs some way to hear/accept/receive the interaction input to
#			close the interaction
#	- The Interaction can be cancelled by releasing the input while a timer is active
#	- Interactions can be force-ended if required
#
# Completing interactions
#	- An interaction is "completed" only if the interaction has an outcome or result
#		- Instant completion: Activating a switch, toggling something
#		- Delayed completion: "Turning in" required items via specific UI; timed use interactions like harvesting
#		- No completion: Standard dialogue
#
#
# Interaction
#	- Active
#	- Cancelled
#	- Ended
#	- Completed
#
# ==========================================







var current_target_entity: EntityNode

var current_target_interactable_component: InteractableComponent

var interaction_timer:= 0.0




func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.interact_pressed.connect(_on_interact_pressed)

		input_component.interact_released.connect(_on_interact_released)







func force_start_interaction(target_entity: EntityNode) -> void:

	_start_interaction(target_entity)






func force_end_interaction() -> void:

	_end_interaction()














func _start_interaction(target_entity: EntityNode) -> void:

	if _is_interacting():
		 
		if interaction_timer > 0.0:

			_cancel_interaction()

		else:

			_end_interaction()

	current_target_entity = target_entity

	current_target_interactable_component = current_target_entity.get_interactable_component()

	current_target_interactable_component.end_requested.connect(_on_interactable_end_requested, CONNECT_ONE_SHOT)

	interaction_timer = current_target_interactable_component._get_duration()

	entity.state_machine.request_state(BodyInteractingState)

	target_entity.state_machine.request_state(BodyInteractingState)

	interaction_timer = current_target_interactable_component._get_duration()

	current_target_interactable_component._start()

	interaction_started.emit()

	





func _end_interaction() -> void:

	if current_target_interactable_component.end_requested.is_connected(_on_interactable_end_requested):

		current_target_interactable_component.end_requested.disconnect(_on_interactable_end_requested)

	entity.state_machine.request_state(BodyIdleState)

	current_target_entity.state_machine.request_state(BodyIdleState)

	current_target_interactable_component = null

	current_target_entity = null

	interaction_timer = 0.0

	interaction_ended.emit()





func _cancel_interaction() -> void:

	current_target_interactable_component._cancel()

	_end_interaction()





func _complete_interaction() -> void:

	current_target_interactable_component._complete()

	_end_interaction()





func _timeout_interaction() -> void:

	_complete_interaction()







func _can_interact_with(target_entity: EntityNode) -> bool:

	return true



func _can_end_interaction() -> bool:

	return true



func _is_interacting() -> bool:

	return entity.state_machine.current_body_state is BodyInteractingState









func _on_interact_pressed() -> void:

	var entity_node = entity.interaction_sensor.get_nearest_entity()

	if entity_node:

		_start_interaction(entity_node)



func _on_interact_released() -> void:

	if _is_interacting() and interaction_timer > 0.0:

		_cancel_interaction()




func _on_interactable_end_requested() -> void:

	_end_interaction()












func _physics_process(delta: float) -> void:

	if !active:

		return

	if interaction_timer > 0.0:

		interaction_timer -= delta

		current_target_interactable_component.update_timer(interaction_timer)

		if interaction_timer <= 0.0:

			_timeout_interaction()