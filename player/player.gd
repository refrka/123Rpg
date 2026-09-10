class_name Player extends CharacterNode







func _initialize() -> void:

	super()

	var profile_overlay = UI.get_overlay(ProfileOverlay)

	profile_overlay.inventory_display.load_inventory(inventory)