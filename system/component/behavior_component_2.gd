class_name BehaviorComponent2 extends Component





var current_behavior: Behavior2

var last_updated_disposition: Disposition




var behaviors: Array[Behavior2]

var dispositions: Array[Disposition]








func _initialize(_entity: EntityNode) -> void:

	super(_entity)

	if !entity.entity_def.behavior_profile:

		return

	for behavior in entity.entity_def.behavior_profile.behaviors:

		var b = behavior.duplicate(true)

		b._initialize(entity)

		b.evaluation_requested.connect(_on_evaluation_requested)

		behaviors.append(b)

	entity.vision_sensor.entity_entered_sensor.connect(_on_entity_entered_vision_sensor)

	entity.vision_sensor.entity_exited_sensor.connect(_on_entity_exited_vision_sensor)










func _evaluate_behavior_list(list: Array[Behavior2] = [], target_disposition: Disposition = null) -> void:

	if list.is_empty():

		list = behaviors

	var best_score:= -INF

	var best_behavior: Behavior2 = null

	for behavior in list:

		var score = behavior._evaluate(target_disposition)

		print(behavior.display_name, ": ", score)

		if !best_behavior or score > best_score:

			best_score = score

			best_behavior = behavior

	print("best?: ", best_behavior.display_name)

	_change_behavior(best_behavior, target_disposition)






func _change_behavior(new_behavior: Behavior2, target_disposition: Disposition = null) -> void:

	if new_behavior == current_behavior:

		return

	if current_behavior:

		current_behavior._stop()

	current_behavior = new_behavior

	current_behavior._start(target_disposition)







func _can_change_behavior(new_behavior: Behavior2) -> bool:

	if !current_behavior or current_behavior.allowed_type_transitions.has(new_behavior.behavior_type):

		return true

	return false







func _get_disposition(target_entity: EntityNode) -> Disposition:

	for disposition in dispositions:

		if disposition.target_entity == target_entity:

			return disposition

	return null




func _generate_disposition(target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.create_new(target_entity)

	disposition.attribute_updated.connect(_on_disposition_attribute_updated.bind(disposition))

	disposition.visibility_updated.connect(_on_disposition_visiblity_updated.bind(disposition))

	disposition.expired.connect(_on_disposition_expired.bind(disposition), CONNECT_ONE_SHOT)

	last_updated_disposition = disposition

	dispositions.append(disposition)

	_evaluate_behavior_list(behaviors, disposition)

	return disposition









func _activate() -> void:

	if entity is Player:

		return

	super()

	_evaluate_behavior_list(behaviors)











func _on_disposition_attribute_updated(attribute: Enums.Attribute, amount: float, disposition: Disposition) -> void:

	last_updated_disposition = disposition

	# Does the disposition update matter to inactive behaviors?	>> evaluation_thresholds
	
	# Does the disposition update trigger a list evaluation or a switch to a specific behavior?	>> List: evaluation_thresholds, specific? Hmm

	# If no to the above: Does the disposition update impact the current behavior?

	#	> If it is the current target disposition, does this invalidate the current behavior? >> targeting_thresholds

	#	> If it is different from the target's disposition, should the current behavior retarget to the new disposition? >> re-evaluate using new disposition, 

	#		does it score higher?

	var behavior_list: Array[Behavior2] = []

	for behavior in behaviors:

		if behavior == current_behavior or _can_change_behavior(behavior):

			for threshold in behavior.evaluation_thresholds:

				if threshold.attribute == attribute:

					var compared_value = amount if threshold.use_delta else disposition.attributes[attribute]

					if threshold.value_meets_threshold(compared_value):

						behavior_list.append(behavior)

	if !behavior_list.is_empty():

		_evaluate_behavior_list(behavior_list)

	else:

		if disposition == current_behavior.current_target_disposition:

			current_behavior._validate_current_target()







func _on_disposition_visiblity_updated(visible: bool, disposition: Disposition) -> void:

	if disposition == current_behavior.current_target_disposition:

		current_behavior._validate_current_target()







func _on_evaluation_requested() -> void:

	var disposition = current_behavior.current_target_disposition

	_evaluate_behavior_list(behaviors, disposition)






func _on_entity_entered_vision_sensor(entity_node: EntityNode) -> void:

	var disposition = _get_disposition(entity_node)

	if disposition:

		disposition.set_visible_state(true)

	else:

		disposition = _generate_disposition(entity_node)





func _on_entity_exited_vision_sensor(entity_node: EntityNode) -> void:

	var disposition = _get_disposition(entity_node)

	if disposition:

		disposition.last_known_position = entity_node.global_position

		disposition.set_visible_state(false)




func _on_disposition_expired(disposition: Disposition) -> void:

	dispositions.erase(disposition)

	disposition.attribute_updated.disconnect(_on_disposition_attribute_updated)




func _on_last_command_executed_before_change(new_behavior: Behavior2, target_disposition: Disposition = null) -> void:

	current_behavior._stop()

	current_behavior = new_behavior

	current_behavior._start(target_disposition)