class_name ItemNode extends EntityNode


@export var pick_up_sensor: Sensor


var item_data: ItemData

var moving_to_entity:= false

var target_entity: EntityNode




func _initialize() -> void:

	super()

	if pick_up_sensor:

		pick_up_sensor.initialize(self)

		pick_up_sensor.entity_entered_sensor.connect(_on_entity_entered_pick_up_sensor)





func set_item_data(_item_data: ItemData) -> void:

	item_data = _item_data

	body_sprite.texture = item_data.item_def.body_sprite_texture





func move_toward_entity(_target_entity: EntityNode) -> void:

	if moving_to_entity:

		return

	moving_to_entity = true

	target_entity = _target_entity






static func drop(_item_data: ItemData, target_position: Vector2) -> ItemNode:

	var item_node = load("res://entity/item_node.tscn").instantiate()

	item_node.set_item_data(_item_data)

	var location = Scenes.get_location()

	location.add_entity_node(item_node, target_position)

	item_node._initialize()

	item_node._activate()

	return item_node












func _activate() -> void:

	super()

	if pick_up_sensor:

		pick_up_sensor.activate()





func _deactivate() -> void:

	super()

	if pick_up_sensor:

		pick_up_sensor.deactivate()






func _on_entity_entered_pick_up_sensor(entity_node: EntityNode) -> void:

	entity_node.inventory.add_item_data(item_data)

	if item_data.is_empty():

		queue_free.call_deferred()

	else:

		target_entity = null

		moving_to_entity = false







func _physics_process(_delta: float) -> void:

	if !active or !moving_to_entity:

		return

	global_position = global_position.move_toward(target_entity.global_position, 3.0)