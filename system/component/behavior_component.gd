class_name BehaviorComponent extends Component





var behaviors: Array[Behavior]

var current_behavior: Behavior

var dispositions: Array[Disposition]








func _initialize(_entity: EntityNode) -> void:

	if initialized or !_entity.entity_def.behavior_profile:

		return

	super(_entity)

	entity.vision_sensor.entity_entered_sensor.connect(_on_entity_entered_sensor)

	entity.vision_sensor.entity_exited_sensor.connect(_on_entity_exited_sensor)

	for behavior in entity.entity_def.behavior_profile.behaviors:

		var b = behavior.duplicate(true)

		behaviors.append(b)

		b.evaluation_requested.connect(_on_evaluation_requested)

		b._initialize(entity)






func get_nearest_disposition() -> Disposition:

	var nearest_disposition: Disposition = null

	var nearest_distance:= INF

	for disposition in dispositions:

		var distance = entity.global_position.distance_to(disposition.target_entity.global_position)

		if !nearest_disposition or distance < nearest_distance:

			nearest_disposition = disposition
			
			nearest_distance = distance

	return nearest_disposition
		







func _evaluate_all(target_disposition: Disposition = null) -> void:

	var best_score:= -INF

	var best_behavior: Behavior = null

	for behavior in behaviors:

		if !target_disposition and behavior.requires_disposition:

			target_disposition = get_nearest_disposition()

		var score = behavior._evaluate(target_disposition)

		if !best_behavior or score < best_score:

			best_score = score

			best_behavior = behavior

	_change_behavior(best_behavior)

	




func _change_behavior(new_behavior: Behavior) -> void:

	if new_behavior == current_behavior:

		return

	if current_behavior:

		current_behavior._stop()

	current_behavior = new_behavior

	current_behavior._start()









func _generate_disposition(target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.new()

	disposition.target_entity = target_entity

	dispositions.append(disposition)

	return disposition






func _activate() -> void:

	super()

	await get_tree().physics_frame

	_evaluate_all.call_deferred()












func _get_disposition(target_entity: EntityNode) -> Disposition:

	for disposition in dispositions:

		if disposition.target_entity == target_entity:

			return disposition

	return null










func _on_evaluation_requested() -> void:

	_evaluate_all()




func _on_entity_entered_sensor(entity_node: EntityNode) -> void:

	var disposition = _get_disposition(entity_node)

	if !disposition:

		_generate_disposition(entity_node)




func _on_entity_exited_sensor(entity_node: EntityNode) -> void:

	pass