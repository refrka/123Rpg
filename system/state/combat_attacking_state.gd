class_name CombatAttackingState extends CombatState


signal attack_finished








func _enter() -> void:

	animation_component.combat_anim_player.animation_finished.connect(_on_combat_animation_finished, CONNECT_ONE_SHOT)

	animation_component.combat_anim_player.play(combat_component.current_animation_name)





func _exit() -> void:

	if animation_component.combat_anim_player.animation_finished.is_connected(_on_combat_animation_finished):

		animation_component.combat_anim_player.animation_finished.disconnect(_on_combat_animation_finished)






func _on_combat_animation_finished(anim_name: String) -> void:

	if anim_name == combat_component.current_animation_name:

		attack_finished.emit()