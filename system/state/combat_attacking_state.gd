class_name CombatAttackingState extends CombatState


signal attack_finished








func _enter() -> void:

	super()

	animation_component.combat_anim_player.play(combat_component.current_animation_name)








func _connect_signals() -> void:

	animation_component.combat_anim_player.animation_finished.connect(_on_combat_animation_finished)




func _disconnect_signals() -> void:

	animation_component.combat_anim_player.animation_finished.disconnect(_on_combat_animation_finished)






func _on_combat_animation_finished(anim_name: String) -> void:

	if anim_name == combat_component.current_animation_name:

		attack_finished.emit()