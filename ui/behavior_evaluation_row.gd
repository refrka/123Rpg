class_name BehaviorEvaluationRow extends HBoxContainer



@export var behavior_name_label: Label

@export var score_label: Label








func load_behavior(behavior: Behavior) -> void:

	behavior_name_label.text = behavior.display_name




func set_score_label(score: float) -> void:

	score_label.text = str(score)