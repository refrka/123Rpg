extends Node




var subscriptions: Dictionary[Script, Array]

var entity_subscriptions: Dictionary[EntityNode, Array]




func _ready() -> void:

	process_mode = Node.PROCESS_MODE_ALWAYS







func subscribe(event_script: Script, callback: Callable) -> void:

	if !subscriptions.has(event_script):

		subscriptions[event_script] = []

	subscriptions[event_script].append(callback)




func subscribe_to_entity(entity_node: EntityNode, callback: Callable) -> void:

	if !entity_subscriptions.has(entity_node):

		entity_subscriptions[entity_node] = []

	entity_subscriptions[entity_node].append(callback)





func unsubscribe(event_script: Script, callback: Callable) -> void:

	if subscriptions.has(event_script) and subscriptions[event_script].has(callback):

		subscriptions[event_script].erase(callback)

		if subscriptions[event_script].is_empty():

			subscriptions.erase(event_script)




func unsubscribe_from_entity(entity_node: EntityNode, callback: Callable) -> void:

	if entity_subscriptions.has(entity_node) and entity_subscriptions[entity_node].has(callback):

		entity_subscriptions[entity_node].erase(callback)

		if entity_subscriptions[entity_node].is_empty():

			entity_subscriptions.erase(entity_node)






func fire(event_script: Script, blackboard: Blackboard = null) -> void:

	var event = event_script.new()

	event.fire(blackboard)

	if subscriptions.has(event_script):

		for callback in subscriptions[event_script]:

			if callback.is_valid():

				callback.call(event)

	if event is EntityEvent:

		var entity_node = event.entity

		if entity_subscriptions.has(entity_node):

			for callback in entity_subscriptions[entity_node]:

				if callback.is_valid():
					
					callback.call(event)