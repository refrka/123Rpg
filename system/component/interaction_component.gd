class_name InteractionComponent extends Component


signal interaction_complete



var target_interactable_entity: EntityNode

var target_interactable_component: InteractableComponent



var current_interaction: Interaction




func _initialize(_entity: EntityNode) -> void:

	super(_entity)






func _start_interaction(target_entity: EntityNode) -> void:

	_set_target_interactable(target_entity)

	current_interaction = Interaction.start(self, target_interactable_component)

	current_interaction.interaction_ended.connect(_on_interaction_ended)

	current_interaction.interaction_complete.connect(_on_interaction_complete)

	current_interaction.interactable_component._start(entity)





func _end_interaction() -> void:

	current_interaction.interactable_component._end()

	current_interaction = null

	target_interactable_entity = null

	target_interactable_component = null




func _complete_interaction() -> void:

	target_interactable_component._complete()

	_end_interaction()

	interaction_complete.emit()




func _cancel_interaction() -> void:

	target_interactable_component._cancel()

	_end_interaction()





func _set_target_interactable(entity_node: EntityNode) -> void:

	target_interactable_entity = entity_node

	target_interactable_component = entity_node.get_interactable_component()





func _can_interact(target_entity: EntityNode) -> bool:

	var interactable_component = target_entity.get_interactable_component()

	if !interactable_component:

		return false

	return true








func _on_interaction_complete() -> void:

	print("interaction complete")

	_complete_interaction()



func _on_interaction_ended() -> void:

	pass




func _physics_process(delta: float) -> void:

	if !active:

		return

	if current_interaction and current_interaction.interaction_timer > 0.0:

		current_interaction.interaction_timer -= delta

		if current_interaction.interaction_timer <= 0.0:

			_complete_interaction()