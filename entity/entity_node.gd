@abstract class_name EntityNode extends PhysicsBody2D





@export var entity_def: EntityDef

@export var component_root: Node

@export var state_machine: StateMachine

@export var vision_sensor: Sensor

@export var interaction_sensor: Sensor

@export var body_hurtbox: Hurtbox

@export var combat_hitbox: Hitbox




var initialized:= false

var active:= false













func _initialize() -> void:

	if initialized:

		return

	initialized = true

	for component in component_root.get_children():

		component._initialize(self)

	if state_machine:

		state_machine._initialize(self)

	if vision_sensor:

		vision_sensor.initialize(self)
		
	if interaction_sensor:

		interaction_sensor.initialize(self)

	if body_hurtbox:

		body_hurtbox.initialize(self)

	if combat_hitbox:

		combat_hitbox.initialize(self)

























func get_state(state_script: Script) -> State:

	if state_machine:

		return state_machine.get_state(state_script)

	return null




func get_component(component_script: Script) -> Component:

	for component in component_root.get_children():

		if component.get_component_script() == component_script:

			return component

	return null




















	


func _activate() -> void:

	if active:

		return

	active = true

	for component in component_root.get_children():

		component._activate()

	if state_machine:

		state_machine._activate()

	if vision_sensor:

		vision_sensor.activate()
		
	if interaction_sensor:

		interaction_sensor.activate()

	if body_hurtbox:

		body_hurtbox.activate()

	if combat_hitbox:

		combat_hitbox.activate()





func _deactivate() -> void:

	if !active:

		return

	active = false

	for component in component_root.get_children():

		component._deactivate()

	if state_machine:

		state_machine._deactivate()

	if vision_sensor:

		vision_sensor.deactivate()
		
	if interaction_sensor:

		interaction_sensor.deactivate()

	if body_hurtbox:

		body_hurtbox.deactivate()

	if combat_hitbox:

		combat_hitbox.deactivate()