class_name EffectsComponent extends Component




var active_effects: Array[EffectData]





func add_effect(effect: Effect) -> EffectData:

	var effect_data = EffectData.new_effect(effect, entity)

	if not effect is InstantEffect:

		active_effects.append(effect_data)

		effect_data.effect_expired.connect(_on_effect_expired.bind(effect_data))

	effect_data._start()

	return effect_data




func remove_effect(effect_data: EffectData) -> void:

	effect_data._stop()

	if active_effects.has(effect_data):

		active_effects.erase(effect_data)





func receive_damage_package(damage_package: DamagePackage) -> void:

	pass





func _on_effect_expired(effect_data: EffectData) -> void:

	remove_effect(effect_data)





func _physics_process(delta: float) -> void:

	if !active: return

	for effect_data in active_effects:

		effect_data._tick(delta)