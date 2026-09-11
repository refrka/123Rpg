class_name DebugOverlay extends UIOverlay



@export var day_label: Label

@export var time_label: Label

@export var start_clock_button: Button

@export var stop_clock_button: Button

@export var reset_clock_button: Button








func _ready() -> void:

	super()

	Clock.tick_changed.connect(_on_tick_changed)

	Clock.hour_changed.connect(_on_hour_changed)

	Clock.day_changed.connect(_on_day_changed)

	start_clock_button.pressed.connect(_on_start_clock_pressed)

	stop_clock_button.pressed.connect(_on_stop_clock_pressed)

	reset_clock_button.pressed.connect(_on_reset_clock_pressed)








func _update_time_label() -> void:
	
	time_label.text = Clock.get_time_string()



func _update_day_label() -> void:

	day_label.text = "Day %s" % Clock.day




func _on_start_clock_pressed() -> void:

	Clock.start()




func _on_stop_clock_pressed() -> void:

	Clock.stop()



func _on_reset_clock_pressed() -> void:

	Clock.reset()








func _on_tick_changed() -> void:

	_update_time_label()



func _on_hour_changed() -> void:

	_update_time_label()



func _on_day_changed() -> void:

	_update_day_label()