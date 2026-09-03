class_name BehaviorComponent extends Component





var behaviors: Array[Behavior]

var current_behavior: Behavior

var dispositions: Array[Disposition]














func _evaluate_all(target_disposition: Disposition = null) -> void:

	for behavior in behaviors:

		var score = behavior._evaluate(target_disposition)

	