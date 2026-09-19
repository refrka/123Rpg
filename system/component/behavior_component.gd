class_name BehaviorComponent extends Component




var attitude: float

var temperament: float


var behaviors: Array[Behavior]

var current_behavior_score: float

var current_behavior: Behavior

var current_target_disposition: Disposition

var dispositions: Array[Disposition]



var evaluation_timer:= 0.0





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






func receive_damage_package(damage_package: DamagePackage) -> void:

	var disposition = _get_disposition(damage_package.source_entity)

	disposition.update_attribute(Enums.Attribute.FEAR, 0.5)





func get_nearest_disposition() -> Disposition:

	var nearest_disposition: Disposition = null

	var nearest_distance:= INF

	for disposition in dispositions:

		if !is_instance_valid(disposition.target_entity):

			continue

		var distance = entity.global_position.distance_to(disposition.target_entity.global_position)

		if !nearest_disposition or distance < nearest_distance:

			nearest_disposition = disposition
			
			nearest_distance = distance

	return nearest_disposition
		





func _evaluate_list(list: Array[Behavior], target_disposition: Disposition = null) -> void:

	if !target_disposition:

		target_disposition = current_target_disposition

	var best_score:= -INF

	var best_behavior: Behavior = null

	for behavior in list:

		var score = behavior._evaluate(target_disposition)

		if !best_behavior or score > best_score:

			best_score = score

			best_behavior = behavior

	if best_behavior == current_behavior:

		_evaluate_current_behavior(target_disposition)

	else:

		best_behavior._change_target_disposition(target_disposition)

		_change_behavior(best_behavior, best_score)












func _evaluate_current_behavior(target_disposition: Disposition) -> void:

	var score = current_behavior._evaluate(target_disposition)

	if score > current_behavior_score:

		current_behavior._change_target_disposition(target_disposition)

	




func _change_behavior(new_behavior: Behavior, score: float) -> void:

	if new_behavior == current_behavior:

		return

	if current_behavior:

		current_behavior._stop()

	current_behavior_score = score

	current_behavior = new_behavior

	current_behavior._start()






func _can_transition_to(new_behavior: Behavior) -> bool:

	if !current_behavior:

		return true

	return current_behavior.allowed_type_transitions.has(new_behavior.behavior_type)









func _generate_disposition(target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.new()

	disposition.target_entity = target_entity

	dispositions.append(disposition)

	disposition.attribute_updated.connect(_on_disposition_attribute_updated.bind(disposition))

	target_entity.entity_died.connect(_on_disposition_entity_died.bind(disposition))

	return disposition







func _activate() -> void:

	super()

	await get_tree().physics_frame

	_evaluate_list.call_deferred(behaviors)












func _get_disposition(target_entity: EntityNode) -> Disposition:

	for disposition in dispositions:

		if disposition.target_entity == target_entity:

			return disposition

	return null










func _on_evaluation_requested() -> void:

	_evaluate_list(behaviors, current_target_disposition)





func _on_entity_entered_sensor(entity_node: EntityNode) -> void:

	if not entity_node is CharacterNode:

		return

	var disposition = _get_disposition(entity_node)

	if !disposition:

		disposition = _generate_disposition(entity_node)

	disposition.target_visible = true





func _on_entity_exited_sensor(entity_node: EntityNode) -> void:

	var disposition = _get_disposition(entity_node)

	if disposition:

		disposition.target_visible = false





func _on_disposition_entity_died(disposition: Disposition) -> void:

	await get_tree().physics_frame

	dispositions.erase(disposition)




func _on_disposition_attribute_updated(attribute: Enums.Attribute, amount: float, disposition: Disposition) -> void:

	var eligible_behaviors: Array[Behavior] = []

	for behavior in behaviors:

		if _can_transition_to(behavior) and !behavior.evaluation_thresholds.is_empty():

			for threshold in behavior.evaluation_thresholds:

				var compared_value = amount if threshold.use_delta else disposition.attributes[attribute]

				if threshold.value_meets_threshold(compared_value):

					eligible_behaviors.append(behavior)

	if !eligible_behaviors.is_empty():

		_evaluate_list(eligible_behaviors, disposition)