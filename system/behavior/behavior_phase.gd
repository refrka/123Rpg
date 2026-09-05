class_name BehaviorPhase extends Resource


@export var phase_name: String

@export var phase_commands: Array[Command]

@export var exit_commands: Array[Command]

@export var transition_events: Dictionary[Script, Command]

@export var phase_command_transition_index:= -1



