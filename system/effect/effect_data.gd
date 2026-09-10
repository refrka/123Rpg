class_name EffectData extends RefCounted


signal effect_expired


var entity: EntityNode

var active:= false

var effect: Effect

var time_alive:= 0.0

var last_tick:= 0.0





func _start() -> void:

	active = true

	effect._apply_effect(entity)




func _stop() -> void:

	active = false

	effect._stop()




func _expire() -> void:

	_stop()

	effect_expired.emit()




func _is_expired() -> bool:

	match effect.effect_type: 

		Effect.EffectType.INSTANT:

			return true

		Effect.EffectType.PASSIVE, Effect.EffectType.TICK:

			if time_alive > effect.duration:

				return true

			else:

				return false

	return true




func _on_effect_expired() -> void:

	active = false

	effect_expired.emit()





static func new_effect(_effect: Effect, _entity: EntityNode) -> EffectData:

	var effect_data = EffectData.new()

	_effect.expired.connect(effect_data._on_effect_expired)

	effect_data.effect = _effect

	effect_data.entity = _entity

	return effect_data



	




func _tick(delta: float) -> void:

	if !active: return

	if effect.duration <= 0.0: return

	time_alive += delta

	if effect is TickEffect and effect.effect_type == Effect.EffectType.TICK and time_alive - last_tick >= effect.tick_rate:

		effect._do_tick(entity)

	if _is_expired():

		effect._expire()
		