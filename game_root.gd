extends Node


@export var location: Location


func _ready() -> void:

	for child in location.ysort_root.get_children():

		child._initialize()

		child._activate()