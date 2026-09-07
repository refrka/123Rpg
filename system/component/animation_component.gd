class_name AnimationComponent extends Component


@export var combat_anim_player: AnimationPlayer






func play_combat_animation(anim_name: StringName) -> void:

	combat_anim_player.play(anim_name)




func play_body_animation(anim_name: String) -> void:

	entity.body_sprite.play(anim_name)