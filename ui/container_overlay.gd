class_name ContainerOverlay extends UIOverlay


@export var container_inventory_display: InventoryDisplay

@export var player_inventory_display: InventoryDisplay




func load_container_inventory(inventory: Inventory) -> void:

	container_inventory_display.load_inventory(inventory)

	var player = Game.get_player()

	player_inventory_display.load_inventory(player.inventory)