class_name UIOverlay extends UIElement


@warning_ignore("unused_signal")

signal deactivate_requested


@export var pause_game:= false




func _enter_tree() -> void:

	UI.register_overlay(self)






func _exit_tree() -> void:

	UI.unregister_overlay(self)