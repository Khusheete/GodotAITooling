class_name GOAPWorld
extends Node


const GLOBAL_WORLD_GROUP: String = "GOAPGlobalWorld"

## If the world is global, every planner will be able to query it when trying to find a state
@export var global: bool = false

var _world_states: Dictionary = {}


func _ready() -> void:
	# Get child states
	for child: Node in get_children():
		if child is GOAPWorldState:
			_world_states[child.name] = child
	
	if global:
		add_to_group(GLOBAL_WORLD_GROUP)


func get_world_state_value(world_state_name: StringName) -> GOAPWorldState:
	return _world_states.get(world_state_name)


func get_complete_state() -> Dictionary:
	var state: Dictionary = {}
	for state_name: StringName in _world_states:
		state[state_name] = _world_states[state_name].get_value()
	return state
