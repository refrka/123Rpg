class_name Player extends CharacterNode






func _initialize() -> void:

	super()

	var blackboard = Blackboard.new()

	blackboard.set_value("player", self)

	Events.fire(PlayerInitializedEvent, blackboard)