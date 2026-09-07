class_name Interaction extends RefCounted


signal completed


enum Status {

	INACTIVE,

	ACTIVE,

	PENDING,

	COMPLETE,

	CANCELLED,

}


# Types:

# - Instant (flip a switch)
# - Duration (harvest a plant)
# - Toggle (open/close dialogue or container)



var actor: EntityNode

var target_entity: EntityNode

var status: Status

var timer:= 0.0




func set_status(_status: Status) -> void:

	status = _status

	if status == Status.COMPLETE:

		completed.emit()



func tick(delta: float) -> void:

	timer -= delta

	if timer <= 0.0:

		set_status(Status.COMPLETE)



static func start_new(_actor: EntityNode, _target_entity: EntityNode) -> Interaction:

	var interaction = Interaction.new()

	interaction.actor = _actor

	interaction.target_entity = _target_entity

	interaction.set_status(Status.ACTIVE)

	var interactable_component = interaction.target_entity.get_interactable_component()

	interaction.timer = interactable_component._get_duration()

	return interaction