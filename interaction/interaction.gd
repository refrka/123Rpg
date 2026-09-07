class_name Interaction extends RefCounted


signal interaction_ended

signal interaction_complete


var interaction_component: InteractionComponent

var interactable_component: InteractableComponent

var interaction_timer:= 0.0






static func start(_interaction_component: InteractionComponent, _interactable_component: InteractableComponent) -> Interaction:

	var interaction = Interaction.new()

	interaction.interaction_component = _interaction_component

	interaction.interactable_component = _interactable_component

	interaction.interactable_component.interaction_complete.connect(interaction._on_interaction_complete, CONNECT_ONE_SHOT)

	interaction.interaction_timer = _interactable_component._get_duration()

	return interaction




func end() -> void:

	interaction_ended.emit()





func _on_interaction_complete() -> void:

	interaction_complete.emit()