class_name InteractableComponent extends Component


signal interaction_complete

@export var interaction_duration: float

var interaction_source: EntityNode




func _start(_interaction_source: EntityNode) -> void:

	interaction_source = _interaction_source

	entity.state_machine.request_state(BodyInteractingState)

	if !entity.entity_def.dialogue_library and !interaction_source.entity_def.dialogue_library:

		interaction_complete.emit()

	else:

		if entity is Player or interaction_source is Player:

			var dialogue_overlay = UI.activate_overlay(DialogueOverlay)

			dialogue_overlay.overlay_closed.connect(_on_dialogue_overlay_closed)
	



func _end() -> void:

	if entity is Player or interaction_source is Player:

		var dialogue_overlay = UI.deactivate_overlay(DialogueOverlay)

		dialogue_overlay.overlay_closed.disconnect(_on_dialogue_overlay_closed)

	entity.state_machine.request_state(BodyIdleState)




func _complete() -> void:

	pass




func _cancel() -> void:

	pass








func _get_duration() -> float:

	return interaction_duration







func _on_dialogue_overlay_closed() -> void:

	interaction_complete.emit()