class_name Modifier extends RefCounted


signal expired


enum ModifierType {

	PASSIVE,

	TIMED,

	DECAY,

}




var value: Variant

var modifier_type: ModifierType

var decay_rate:= -1.0

var duration:= -1.0




var _time_alive:= 0.0



func _is_expired() -> bool:

	match modifier_type:

		ModifierType.TIMED:

			return _time_alive >= duration

		ModifierType.DECAY:

			if value is float:

				return value < 0.001

			elif value is Vector2:

				return value.length_squared() < 0.001

	return false







static func new_passive(_value: Variant) -> Modifier:

	var modifier = Modifier.new()

	modifier.modifier_type = ModifierType.PASSIVE

	modifier.value = _value

	return modifier




static func new_timed(_value: Variant, _duration: float) -> Modifier:

	var modifier = Modifier.new()

	modifier.modifier_type = ModifierType.TIMED

	modifier.value = _value

	modifier.duration = _duration

	return modifier



static func new_decay(_value: Variant, _decay_rate: float) -> Modifier:

	var modifier = Modifier.new()

	modifier.modifier_type = ModifierType.DECAY

	modifier.value = _value

	modifier.decay_rate = _decay_rate

	return modifier





static func get_modifier() -> Modifier:

	return null




func _tick(delta: float) -> void:

	_time_alive += delta

	if decay_rate > 0.0:

		value *= clampf(1.0 - decay_rate * delta, 0.0, 1.0)

	if _is_expired():

		expired.emit()








	