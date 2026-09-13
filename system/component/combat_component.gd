class_name CombatComponent extends Component



signal attack_finished

signal attack_cancelled




@export var combat_origin: Node2D



var current_attack_config: AttackConfig

var current_attack_index: int

var current_library_name: String

var current_animation_name: String

var current_attack_dir:= Vector2.RIGHT




var buffer_enabled:= false

var buffered:= false



var cooldown_enabled:= false

var cooldown_timer:= 0.0




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

	entity.combat_hitbox.hit_detected.connect(_on_combat_hit_detected)







func _enter_combat() -> void:

	entity.state_machine.request_state(CombatReadyState)








func _try_attack() -> bool:

	if not _is_attacking() and _is_attack_index_valid(current_attack_index):
		
		if not cooldown_enabled:

			_start_attack()

			return true

	else:

		if buffer_enabled:

			var buffered_index = current_attack_index + 1

			if _is_attack_index_valid(buffered_index):

				buffered = true

			buffer_enabled = false

		else:

			return false

	return false







func _start_attack() -> void:

	var attack_entry = _get_attack_entry()

	if not _is_in_combat():

		_enter_combat()

	current_animation_name = _get_current_attack_animation_name()

	_set_attack_dir()

	entity.state_machine.request_state(CombatAttackingState)

	if attack_entry.cooldown_duration > 0.0:

		_start_cooldown()




func _finish_attack() -> void:

	entity.combat_hitbox.clear_hit_list()

	attack_finished.emit()

	if buffered:

		buffered = false

		current_attack_index += 1

		_start_attack()

	else:

		current_attack_index = 0

		entity.state_machine.request_state(CombatReadyState)






func _cancel_attack() -> void:

	attack_cancelled.emit()






func _start_cooldown() -> void:

	var attack_entry = _get_attack_entry()

	cooldown_timer = attack_entry.cooldown_duration

	cooldown_enabled = true





func _end_cooldown() -> void:

	cooldown_enabled = false

	cooldown_timer = 0.0









func _generate_damage_package() -> DamagePackage:

	var attack_entry = _get_attack_entry()

	var damage_package = DamagePackage.from_attack_entry(attack_entry)

	damage_package.source_entity = entity

	return damage_package
















func _set_buffer_enabled_state(state: bool) -> void:

	buffer_enabled = state



func _set_attack_dir() -> void:

	var dir = _get_current_attack_dir()

	if dir != current_attack_dir:

		current_attack_dir = dir

		combat_origin.rotation = current_attack_dir.angle()






func _get_current_attack_animation_name() -> String:

	return "%s/attack_%s" % [current_library_name, current_attack_index]


func _get_current_charge_animation_name() -> String:

	return "%s/charge_%s" % [current_library_name, current_attack_index]


func _get_current_attack_dir() -> Vector2:

	if entity is Player:

		return combat_origin.global_position.direction_to(entity.get_global_mouse_position())

	var movement_component = entity.get_component(MovementComponent)

	return movement_component.face_dir


func _get_attack_entry(index:= -1) -> AttackEntry:

	if index == -1:

		index = current_attack_index

	if !_is_attack_index_valid(index):

		return null

	return current_attack_config.attack_set[index]




func _is_in_combat() -> bool:

	return not entity.state_machine.current_combat_state is CombatIdleState



func _is_attacking() -> bool:

	return entity.state_machine.current_combat_state is CombatAttackingState



func _is_attack_index_valid(index: int) -> bool:

	if !current_attack_config or current_attack_config.attack_set.size() - 1 < index:

		return false

	return true

















func _on_combat_ready_expired() -> void:

	entity.state_machine.request_state(CombatIdleState)



func _on_attack_input_pressed() -> void:

	_try_attack()



func _on_attack_input_released() -> void:

	pass



func _on_attack_finished() -> void:

	_finish_attack()



func _on_combat_hit_detected(entity_node: EntityNode) -> void:

	var damage_package = _generate_damage_package()

	entity_node.receive_damage_package(damage_package)







func _process(delta: float) -> void:

	if cooldown_enabled and cooldown_timer > 0.0:

		cooldown_timer -= delta

		if cooldown_timer <= 0.0:

			_end_cooldown()