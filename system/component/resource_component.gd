class_name ResourceComponent extends InteractableComponent




var resource_config: ResourceConfig

var interact_timer:= 0.0



func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	resource_config = entity.entity_def.resource_config








func _start_interacting() -> bool:

	super()

	if !resource_config or resource_config.interact_duration <= 0.0:

		return false

	interact_timer = resource_config.interact_duration

	progress_bar.max_value = resource_config.interact_duration

	progress_bar.show()

	return true




func _end_interacting() -> bool:

	super()

	progress_bar.hide()

	return true




func _complete_interacting() -> bool:

	super()

	# Dip into config for items to drop

	interaction_complete.emit()

	return true




func _is_held_interaction() -> bool:

	return true





func _get_duration() -> float:

	return resource_config.interact_duration






func _process(delta: float) -> void:

	if !active:

		return

	if interact_timer > 0.0:

		interact_timer -= delta

		progress_bar.value = progress_bar.max_value - interact_timer

		if interact_timer <= 0.0:

			_complete_interacting()