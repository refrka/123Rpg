class_name InteractionComponent extends Component





var target_interactable_entity: EntityNode

var target_interactable_component: InteractableComponent


var interaction_timer: SceneTreeTimer



func _initialize(_entity: EntityNode) -> void:

	super(_entity)






func _start_interaction(target_entity: EntityNode) -> void:

	_set_target_interactable(target_entity)

	target_interactable_component._start()

	var duration = target_interactable_component._get_duration()

	if duration > 0.0:

		interaction_timer = Game.get_tree().create_timer(duration)

		interaction_timer.timeout.connect(_on_interaction_duration_complete, CONNECT_ONE_SHOT)



func _end_interaction() -> void:

	target_interactable_component._end()

	target_interactable_entity = null

	target_interactable_component = null

	if interaction_timer:

		interaction_timer.timeout.disconnect(_on_interaction_duration_complete)




func _complete_interaction() -> void:

	target_interactable_component._complete()

	_end_interaction()




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











func _on_interaction_duration_complete() -> void:

	_complete_interaction()