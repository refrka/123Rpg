class_name BehaviorComponent extends Component


signal behavior_evaluated(behavior: Behavior, score: float)

signal behavior_changed(behavior: Behavior)





var behaviors: Array[Behavior]

var current_behavior: Behavior

var dispositions: Array[Disposition]

var attitude: float

var temperament: float






func _initialize(_entity: EntityNode) -> void:

	if initialized or !_entity.entity_def.behavior_profile:

		return

	super(_entity)

	var behavior_profile = entity.entity_def.behavior_profile

	for behavior in entity.entity_def.behavior_profile.behaviors:

		var b = behavior.duplicate(true)

		behaviors.append(b)

		b._initialize(entity)
		
	entity.vision_sensor.entity_entered_sensor.connect(_on_entity_entered_sensor)

	attitude = behavior_profile.default_baseline.get_value(Behavior.Attribute.ATTITUDE)

	temperament = behavior_profile.default_baseline.get_value(Behavior.Attribute.TEMPERAMENT)




func receive_damage_package(damage_package: DamagePackage) -> void:

	var disposition = _get_disposition(damage_package.source_entity)

	if disposition:
		
		var damage_baseline = entity.entity_def.behavior_profile.damage_baseline

		disposition.add_baseline(damage_baseline)






func _evaluate_all(target_disposition: Disposition = null) -> void:

	var best_score:= -INF

	var best_behavior: Behavior = null

	for behavior in behaviors:

		var score = behavior._evaluate(target_disposition)

		behavior_evaluated.emit(behavior, score)

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

	behavior_changed.emit(new_behavior)







func _create_disposition(target_entity: EntityNode) -> Disposition:

	var disposition = Disposition.new()

	disposition.target_entity = target_entity

	dispositions.append(disposition)

	return disposition





func _get_disposition(target_entity: EntityNode) -> Disposition:

	for disposition in dispositions:

		if disposition.target_entity == target_entity:

			return disposition

	return null








func _on_entity_entered_sensor(entity_node: EntityNode) -> void:

	var disposition = _get_disposition(entity_node)

	if !disposition:

		disposition = _create_disposition(entity_node)

		disposition.add_baseline(entity.entity_def.behavior_profile.default_baseline)

		if entity.entity_def.behavior_profile.entity_baselines.has(entity_node.entity_def):

			var baseline = entity.entity_def.behavior_profile.entity_baselines[entity_node.entity_def]

			disposition.add_baseline(baseline)






func _activate() -> void:

	super()

	_evaluate_all()





