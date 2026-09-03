extends Node




func _ready() -> void:

	var player = load("res://player/player.tscn").instantiate()

	var thief = load("res://entity/characters/enemies/thief.tscn").instantiate()

	var location = Scenes.get_location()

	location.add_entity_node(player, Vector2(200.0, 200.0))

	location.add_entity_node(thief, Vector2(400.0, 200.0))

	player._initialize()

	player._activate()

	thief._initialize()

	thief._activate()

