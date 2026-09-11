class_name CombatComponent extends Component


@export var combat_origin: Node2D



var current_attack_config: AttackConfig

var current_attack_index: int

var current_library_name: String

var current_animation_name: String

var current_attack_dir:= Vector2.RIGHT





func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var ready_state = entity.state_machine.get_state(CombatReadyState)

	ready_state.ready_expired.connect(_on_combat_ready_expired)

	var attacking_state = entity.state_machine.get_state(CombatAttackingState)

	attacking_state.attack_finished.connect(_on_attack_finished)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.attack_pressed.connect(_on_attack_input_pressed)

		input_component.attack_released.connect(_on_attack_input_released)

	if entity.inventory and entity.inventory.weapon_data:

		current_attack_config = entity.inventory.weapon_data.item_def.default_attack_config

		current_library_name = entity.inventory.weapon_data.item_def.item_id

	else:

		current_attack_config = entity.entity_def.melee_attack_config

		current_library_name = entity.entity_def.entity_id







func _enter_combat() -> void:

	entity.state_machine.request_state(CombatReadyState)








func _try_attack() -> void:

	_start_atack()







func _start_atack() -> void:

	if !_is_in_combat():

		_enter_combat()

	current_animation_name = _get_current_attack_animation_name()

	entity.state_machine.request_state(CombatAttackingState)




func _finish_attack() -> void:

	entity.state_machine.request_state(CombatReadyState)










func _set_attack_dir(dir: Vector2) -> void:

	if dir != current_attack_dir:

		current_attack_dir = dir

		combat_origin.rotation = current_attack_dir.angle()





func _get_current_attack_animation_name() -> String:

	return "%s/attack_%s" % [current_library_name, current_attack_index]


func _get_current_charge_animation_name() -> String:

	return "%s/charge_%s" % [current_library_name, current_attack_index]







func _is_in_combat() -> bool:

	return not entity.state_machine.current_combat_state is CombatIdleState



func _is_attacking() -> bool:

	return entity.state_machine.current_combat_state is CombatAttackingState





















func _on_combat_ready_expired() -> void:

	entity.state_machine.request_state(CombatIdleState)



func _on_attack_input_pressed() -> void:

	_try_attack()



func _on_attack_input_released() -> void:

	pass



func _on_attack_finished() -> void:

	_finish_attack()