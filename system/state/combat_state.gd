class_name CombatState extends State


@export var override_body_state:= false




var combat_component: CombatComponent

var animation_component: AnimationComponent



func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	super(_entity, _state_machine)

	combat_component = entity.get_component(CombatComponent)

	animation_component = entity.get_component(AnimationComponent)











func _enter() -> void:

	super()

	if override_body_state:

		_transition(BodyCombatOverrideState)





func _exit() -> void:

	super()

	if override_body_state:

		_transition(BodyIdleState)