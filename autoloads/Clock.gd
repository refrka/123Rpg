extends Node


signal tick_changed()

signal hour_changed()

signal day_changed()


const DELTA_PER_TICK = 1.5

const TICKS_PER_HOUR = 30

const HOURS_PER_DAY = 12





var active:= false


var tick:= 0.0

var hour:= 0

var day:= 1










func start() -> void:

	active = true

	set_tick(tick)

	set_hour(hour)

	set_day(day)





func stop() -> void:

	active = false




func reset() -> void:

	stop()

	set_day(1)

	set_hour(0)

	set_tick(0.0)




func start_day() -> void:

	start()
	





func end_day() -> void:

	stop()

	var new_day = day + 1

	set_day(new_day)

	reset_day()







func reset_day() -> void:

	hour = 0

	tick = 0





func set_tick(_tick: float) -> void:

	var previous_tick = tick

	tick = _tick

	if tick != previous_tick:

		tick_changed.emit()



func set_hour(_hour: int) -> void:

	hour = _hour

	hour_changed.emit()



func set_day(_day: int) -> void:

	day = _day

	day_changed.emit()





func get_time_label() -> String:

	var _tick = int(floor(tick))

	var tick_string = "%s" % _tick

	if _tick < 10:

		tick_string = "0%s" % tick_string

	return "%s : %s" % [hour, tick_string]








func _process(delta: float) -> void:

	if active:

		var new_tick = tick + (delta * 1 / DELTA_PER_TICK)

		if new_tick >= TICKS_PER_HOUR:

			new_tick -= TICKS_PER_HOUR

			set_tick(new_tick)

			var new_hour = hour + 1

			set_hour(new_hour)

			if hour >= HOURS_PER_DAY:

				end_day()

		else:
		
			set_tick(new_tick)