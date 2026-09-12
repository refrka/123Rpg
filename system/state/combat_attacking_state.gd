class_name CombatAttackingState extends CombatState


signal attack_finished



var movement_component: MovementComponent

var modifier: Modifier



func _initialize(_entity: EntityNode, _state_machine: StateMachine) -> void:

	super(_entity, _state_machine)

	movement_component = entity.get_component(MovementComponent)







func _enter() -> void:

	super()

	if modifier:

		movement_component.modifier_tracker.remove_modifier(modifier)

	animation_component.combat_anim_player.play(combat_component.current_animation_name)

	var attack_entry = combat_component._get_attack_entry()

	modifier = Modifier.new_passive(attack_entry.speed_factor)

	movement_component.modifier_tracker.add_modifier(modifier)





func _exit() -> void:

	super()

	movement_component.modifier_tracker.remove_modifier(modifier)





func _connect_signals() -> void:

	animation_component.combat_anim_player.animation_finished.connect(_on_combat_animation_finished)




func _disconnect_signals() -> void:

	animation_component.combat_anim_player.animation_finished.disconnect(_on_combat_animation_finished)






func _on_combat_animation_finished(anim_name: String) -> void:

	if anim_name == combat_component.current_animation_name:

		attack_finished.emit()