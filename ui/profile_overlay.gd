class_name ProfileOverlay extends UIOverlay



@export var inventory_grid: InventoryGrid





func _ready() -> void:

	UI.deactivate_overlay(ProfileOverlay)

	Events.subscribe(PlayerInitializedEvent, _on_player_initialized)




func _on_player_initialized(event: Event) -> void:

	var player = event.blackboard.get_value("player")

	inventory_grid.load_inventory(player.inventory)













func _activate() -> void:

	super()

	inventory_grid._activate()



func _deactivate() -> void:

	super()

	inventory_grid._deactivate()