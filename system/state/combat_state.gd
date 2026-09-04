class_name CombatState extends State


@export var override_body_state:= false






func _enter() -> void:

	super()

	if override_body_state:

		_transition(BodyCombatOverrideState)





func _exit() -> void:

	super()

	if override_body_state:

		_transition(BodyIdleState)