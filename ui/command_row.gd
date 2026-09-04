class_name CommandRow extends HBoxContainer


@export var arrow_label: Label

@export var command_name_label: Label

@export var result_label: Label

@export var awaiting_result_label: Label







func load_command(command: Command) -> void:

	command_name_label.text = command.display_name

	var result_text = Command.Result.keys()[command.result]

	result_label.text = result_text

	command.result_changed.connect(_on_result_changed)




func _on_result_changed(result: Command.Result) -> void:

	var result_text = Command.Result.keys()[result]

	result_label.text = result_text