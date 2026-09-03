class_name StateMachine extends Node




signal state_changed(new_state: State)



@export var initial_body_state: BodyState

@export var initial_combat_state: CombatState

@export var body_root: Node

@export var combat_root: Node



var initialized:= false

var active:= false

var entity: EntityNode




var current_body_state: BodyState

var current_combat_state: CombatState






func _initialize(_entity: EntityNode) -> void:

	if initialized:

		return

	initialized = true

	entity = _entity

	for state in get_body_states():

		state._initialize(entity, self)

	for state in get_combat_states():

		state._initialize(entity, self)

	if initial_body_state:

		current_body_state = initial_body_state

	if initial_combat_state:

		current_combat_state = initial_combat_state










func request_state(state_script: Script) -> State:

	var state = get_state(state_script)

	if state:

		_change_state(state)

	return state













func get_state(state_script: Script) -> State:

	for state in get_body_states() + get_combat_states():

		if state.get_state_script() == state_script:

			return state

	return null





func get_body_states() -> Array:

	return body_root.get_children()




func get_combat_states() -> Array:

	return combat_root.get_children()











func _change_state(new_state: State) -> void:

	if new_state is BodyState:

		if new_state == current_body_state and current_body_state.allow_reenter:

			current_body_state._enter()

			return

		if current_body_state:

			current_body_state._exit()

		current_body_state = new_state

		current_body_state._enter()

		state_changed.emit(current_body_state)

	elif new_state is CombatState:

		if new_state == current_body_state and current_body_state.allow_reenter:

			current_combat_state._enter()

			return

		if current_combat_state:

			current_combat_state._exit()

		current_combat_state = new_state

		current_combat_state._enter()

		state_changed.emit(current_combat_state)











func _activate() -> void:

	if active:

		return

	active = true

	if current_body_state:

		current_body_state._enter()

	if current_combat_state:

		current_combat_state._enter()






func _deactivate() -> void:

	if !active:

		return

	active = false

	if current_body_state:

		current_body_state._exit()

	if current_combat_state:

		current_body_state._exit()

	