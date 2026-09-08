class_name InteractableComponent extends Component


signal end_requested


@export var progress_bar: ProgressBar

@export var interaction_duration:= 0.0






func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	if progress_bar:

		progress_bar.max_value = interaction_duration

		progress_bar.hide()





func update_timer(timer_value: float) -> void:

	var value = interaction_duration - timer_value

	progress_bar.value = value




func _start() -> void:

	var dialogue_overlay = UI.activate_overlay(DialogueOverlay)

	dialogue_overlay.overlay_closed.connect(_on_dialogue_overlay_closed, CONNECT_ONE_SHOT)




func _cancel() -> void:

	pass




func _complete() -> void:

	pass









func _get_duration() -> float:

	return interaction_duration







func _on_dialogue_overlay_closed() -> void:

	end_requested.emit()