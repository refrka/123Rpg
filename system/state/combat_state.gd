class_name CombatState extends State





var combat_component: CombatComponent

var animation_component: AnimationComponent





func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	super(_entity, _state_machine)

	combat_component = entity.get_component(CombatComponent)

	animation_component = entity.get_component(AnimationComponent)