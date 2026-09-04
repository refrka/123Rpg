class_name UIOverlay extends UIElement



@export var pause_game:= false




func _enter_tree() -> void:

	UI.register_overlay(self)






func _exit_tree() -> void:

	UI.unregister_overlay(self)