class_name CombatReadyState extends CombatState


signal ready_expired



@export var ready_duration:= 3.0

var ready_timer:= 0.0







func _enter() -> void:

	super()
	
	ready_timer = ready_duration













func _tick(delta: float) -> void:

	if ready_timer > 0.0:

		ready_timer -= delta

		if ready_timer <= 0.0:

			ready_expired.emit()