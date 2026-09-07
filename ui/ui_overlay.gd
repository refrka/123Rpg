class_name UIOverlay extends UIElement


signal overlay_closed


@export var pause_game:= false




func _enter_tree() -> void:

	UI.register_overlay(self)




func _ready() -> void:

	_deactivate()

	hide()




func close() -> void:

	overlay_closed.emit()



func _exit_tree() -> void:

	UI.unregister_overlay(self)