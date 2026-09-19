class_name AnimationComponent extends Component





@export var body_anim_player: AnimationPlayer

@export var combat_anim_player: AnimationPlayer








func play_idle_dir(dir: Vector2) -> void:

	if dir.x != 0.0:

		_set_body_flip_state(dir.x < 0.0)

	var anim_name = "idle_down" if dir.y >= 0.0 else "idle_up"

	entity.body_animated_sprite.play(anim_name)






func play_moving_dir(dir: Vector2) -> void:

	if dir.x != 0.0:

		_set_body_flip_state(dir.x < 0.0)

	var anim_name = "moving_down" if dir.y >= 0.0 else "moving_up"

	entity.body_animated_sprite.play(anim_name)







func _set_body_flip_state(state: bool) -> void:

	entity.body_sprite.flip_h = state

	entity.body_animated_sprite.flip_h = state