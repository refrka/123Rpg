class_name BehaviorOverlay extends UIOverlay




@onready var command_row_scene:= preload("res://ui/command_row.tscn")

@onready var behavior_evaluation_row_scene:= preload("res://ui/behavior_evaluation_row.tscn")





@export var entity_name_label: Label

@export var behavior_name_label: Label

@export var evaluating_label: Label

@export var behavior_score_label: Label

@export var phase_name_label: Label

@export var phase_command_list: VBoxContainer

@export var behavior_evaluation_list: VBoxContainer



var entity: EntityNode

var behavior: Behavior

var behavior_evaluation_rows: Dictionary[Behavior, BehaviorEvaluationRow]




func load_entity(_entity: EntityNode) -> void:

	_clear_behavior_evaluation_list()

	entity = _entity

	entity_name_label.text = entity.entity_def.display_name

	var behavior_component = entity.get_component(BehaviorComponent)

	behavior_component.behavior_evaluated.connect(_on_behavior_evaluated)

	behavior_component.behavior_changed.connect(_on_behavior_changed)

	for _behavior in behavior_component.behaviors:

		var behavior_evaluation_row = behavior_evaluation_row_scene.instantiate()

		behavior_evaluation_list.add_child(behavior_evaluation_row)

		behavior_evaluation_row.load_behavior(_behavior)

		behavior_evaluation_rows[_behavior] = behavior_evaluation_row





func _clear_phase_command_list() -> void:

	for child in phase_command_list.get_children():

		child.queue_free()




func _clear_behavior_evaluation_list() -> void:

	for child in behavior_evaluation_list.get_children():

		child.queue_free()







func _load_behavior(_behavior: Behavior) -> void:

	behavior = _behavior

	behavior.phase_entered.connect(_on_phase_entered)

	var phase = behavior.get_phase(behavior.current_phase_index)

	_load_phase(phase)

	behavior_name_label.text = behavior.display_name




func _load_phase(phase: BehaviorPhase) -> void:

	_clear_phase_command_list()

	phase_name_label.text = phase.phase_name

	for command in phase.phase_commands:

		var command_row = command_row_scene.instantiate()

		command_row.load_command(command)

		phase_command_list.add_child(command_row)






func _on_behavior_evaluated(_behavior: Behavior, score: float) -> void:

	var evaluation_row = behavior_evaluation_rows[_behavior]

	evaluation_row.set_score_label(score)




func _on_behavior_changed(_behavior: Behavior) -> void:

	_load_behavior(_behavior)





func _on_phase_entered(phase: BehaviorPhase) -> void:

	phase_name_label.text = phase.phase_name

