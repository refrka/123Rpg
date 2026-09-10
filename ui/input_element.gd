class_name InputElement extends UIElement



signal hover_state_changed(state: bool)

signal select_input_received(button_index: int, pressed: bool)


@export var hover_enabled:= true

@export var select_enabled:= true







func _ready() -> void:

	if hover_enabled:

		_connect_hover()

	if select_enabled:

		_connect_select_input()





func _connect_hover() -> void:

	mouse_entered.connect(_on_mouse_entered)

	mouse_exited.connect(_on_mouse_exited)




func _disconnect_hover() -> void:

	mouse_entered.disconnect(_on_mouse_entered)

	mouse_exited.disconnect(_on_mouse_exited)




func _connect_select_input() -> void:

	gui_input.connect(_on_gui_input)




func _disconnect_select_input() -> void:

	gui_input.disconnect(_on_gui_input)









func _on_mouse_entered() -> void:

	hover_state_changed.emit(true)



func _on_mouse_exited() -> void:

	hover_state_changed.emit(false)



func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton:

		select_input_received.emit(event.button_index, event.is_pressed())