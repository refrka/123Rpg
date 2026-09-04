class_name CombatAttackingState extends CombatState







func _enter() -> void:

	super()

	animation_component.combat_anim_player.play(combat_component.current_animation_name)