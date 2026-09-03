class_name Sensor extends Area2D


signal entity_entered_sensor(entity_node: EntityNode)

signal entity_exited_sensor(entity_node: EntityNode)

signal sensor_entered_sensor(sensor: Sensor)

signal sensor_exited_sensor(sensor: Sensor)

signal entity_entered_shape(entity_node: EntityNode, local_shape_index: int)

signal entity_exited_shape(entity_node: EntityNode, local_shape_index: int)



var _initialized:= false

var active:= false

var entity: EntityNode


var entities: Array[EntityNode]

var sensors: Array[Sensor]





func initialize(_entity: EntityNode = null) -> void:

	if _initialized:

		return

	_initialized = true

	entity = _entity





func activate() -> void:

	if active:

		return

	active = true

	_connect_signals()





func deactivate() -> void:

	if !active:

		return

	active = false

	_disconnect_signals()





func _connect_signals() -> void:

	body_entered.connect(_on_body_entered_sensor)

	body_exited.connect(_on_body_exited_sensor)

	area_entered.connect(_on_area_entered_sensor)

	area_exited.connect(_on_area_exited_sensor)

	body_shape_entered.connect(_on_body_shape_entered_shape)

	body_shape_exited.connect(_on_body_shape_exited_shape)



func _disconnect_signals() -> void:

	body_entered.disconnect(_on_body_entered_sensor)

	body_exited.disconnect(_on_body_exited_sensor)

	area_entered.disconnect(_on_area_entered_sensor)

	area_exited.disconnect(_on_area_exited_sensor)






func _on_body_entered_sensor(body: PhysicsBody2D) -> void:

	if body is EntityNode and body != entity:

		entities.append(body)

		entity_entered_sensor.emit(body)



func _on_body_exited_sensor(body: PhysicsBody2D) -> void:

	if entities.has(body):

		entities.erase(body)

		entity_exited_sensor.emit(body)





func _on_area_entered_sensor(area: Area2D) -> void:

	if area is Sensor:

		sensors.append(area)

		sensor_entered_sensor.emit(area)




func _on_area_exited_sensor(area: Area2D) -> void:

	if sensors.has(area):

		sensors.erase(area)

		sensor_exited_sensor.emit(area)




func _on_body_shape_entered_shape(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:

	if body is EntityNode and body != entity:

		entity_entered_shape.emit(body, local_shape_index)





func _on_body_shape_exited_shape(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:

	if body is EntityNode and body != entity:

		entity_exited_shape.emit(body, local_shape_index)