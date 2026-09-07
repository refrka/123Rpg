class_name GameMenu extends UIOverlay



@export var resume_button: Button

@export var quit_button: Button





func _ready() -> void:

	resume_button.pressed.connect(_on_resume_pressed)

	quit_button.pressed.connect(_on_quit_pressed)









func _on_resume_pressed() -> void:

	deactivate_requested.emit()



func _on_quit_pressed() -> void:

	get_tree().quit()