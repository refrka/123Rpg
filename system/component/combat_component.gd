class_name CombatComponent extends Component





@export var combat_origin: Node2D




var current_attack_config: AttackConfig

var current_attack_index:= 0

var current_attack_dir: Vector2

var current_library_name: String

var current_animation_name: String








func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	var input_component = entity.get_component(InputComponent)

	if input_component:

		input_component.attack_pressed.connect(_on_attack_input_pressed)

		input_component.attack_released.connect(_on_attack_input_released)

	if entity.inventory:

		if !entity.inventory.weapon_data.is_empty():

			var weapon_def = entity.inventory.weapon_data.item_def

			current_attack_config = weapon_def.attack_config

			current_library_name = weapon_def.item_id

	entity.combat_hitbox.hit_detected.connect(_on_combat_hit_detected)

	var animation_component = entity.get_component(AnimationComponent)

	animation_component.combat_anim_player.animation_finished.connect(_on_combat_animation_finished)
	







func get_attack_entry(index:= -1) -> AttackEntry:

	if index == -1:

		index = current_attack_index

	if current_attack_config.attack_set.size() - 1 >= index:

		return current_attack_config.attack_set[index]
	
	return null








func _handle_attack_input(pressed: bool) -> void:

	if pressed:

		if !_is_attacking():

			_try_attack()













func _try_attack() -> void:

	_start_attack()





func _start_attack() -> void:

	var attack_dir = _get_attack_dir()

	_set_attack_dir(attack_dir)
	
	current_animation_name = _get_attack_animation_name()

	entity.state_machine.request_state(CombatAttackingState)





func _end_attack() -> void:

	entity.combat_hitbox.clear_hit_list()

	entity.state_machine.request_state(CombatReadyState)















func _set_attack_dir(dir: Vector2) -> void:

	current_attack_dir = dir

	combat_origin.rotation = current_attack_dir.angle()




func _get_attack_animation_name() -> String:

	return "%s/attack_%s" % [current_library_name, current_attack_index]




func _get_attack_dir() -> Vector2:

	if entity is Player:

		return entity.global_position.direction_to(entity.get_global_mouse_position())
	
	return Vector2.RIGHT










func _is_attacking() -> bool:

	return entity.state_machine.current_combat_state is CombatAttackingState











func _on_attack_input_pressed() -> void:

	_handle_attack_input(true)




func _on_attack_input_released() -> void:

	_handle_attack_input(false)




func _on_combat_hit_detected(entity_node: EntityNode) -> void:

	var attack_entry = get_attack_entry()
	
	var damage_package = DamagePackage.from_attack_entry(attack_entry)

	entity_node.receive_damage_package(damage_package)




func _on_combat_animation_finished(anim_name: StringName) -> void:

	if anim_name == current_animation_name:

		_end_attack()