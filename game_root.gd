extends Node




func _ready() -> void:

	var player = load("res://player/player.tscn").instantiate()

	var location = Scenes.get_location()

	location.add_entity_node(player, Vector2(200.0, 200.0))

	player._initialize()

	player._activate()

