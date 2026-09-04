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





func _clear_phase_command_list() -> void:

	for child in phase_command_list.get_children():

		child.queue_free()




func _clear_behavior_evaluation_list() -> void:

	for child in behavior_evaluation_list.get_children():

		child.queue_free()


