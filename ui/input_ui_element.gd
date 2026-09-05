class_name InputUIElement extends UIElement


signal select_input_received

signal hover_input_received


@export var input_group_name: StringName

@export var linked_panel: PanelContainer

@export var select_enabled:= false

@export var hover_enabled:= false

@export var default_stylebox: StyleBoxFlat

@export var hovered_stylebox: StyleBoxFlat

@export var selected_stylebox: StyleBoxFlat


var hovered:= false

var selected:= false





func _ready() -> void:

	_update_stylebox()

	if hover_enabled:

		_connect_hover()

	if select_enabled:

		_connect_select_input()

	if input_group_name != &"":

		add_to_group(input_group_name)




func set_hover_state(state: bool) -> void:

	hovered = state

	_update_stylebox()





func set_select_state(state: bool) -> void:

	selected = state

	_update_stylebox()








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







func _update_stylebox() -> void:

	if selected:

		linked_panel.add_theme_stylebox_override("panel", selected_stylebox)

	elif hovered:

		linked_panel.add_theme_stylebox_override("panel", hovered_stylebox)

	else:

		linked_panel.add_theme_stylebox_override("panel", default_stylebox)







func _activate() -> void:

	super()

	if hover_enabled:

		_connect_hover()

	if select_enabled:

		_connect_select_input()






func _deactivate() -> void:

	super()

	if hover_enabled:

		_disconnect_hover()

	if select_enabled:

		_disconnect_select_input()






func _on_mouse_entered() -> void:

	hover_input_received.emit(true)



func _on_mouse_exited() -> void:

	hover_input_received.emit(false)




func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:

		select_input_received.emit()