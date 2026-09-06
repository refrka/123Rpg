extends Node

@export var location: Location


func _ready() -> void:

	for entity in location.ysort_root.get_children():

		entity._initialize()

		entity._activate()