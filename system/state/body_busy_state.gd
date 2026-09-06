class_name BodyBusyState extends BodyState



var movement_component: MovementComponent



func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	super(_entity, _state_machine)

	movement_component = entity.get_component(MovementComponent)






func _enter() -> void:

	super()

	movement_component.halt()





func _exit() -> void:

	super()