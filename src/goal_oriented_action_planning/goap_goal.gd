class_name GOAPGoal
extends Node


@export var priority: int = 0
@export var desired_world_states: Dictionary = {}


# Function to override
func is_valid() -> bool:
	return true


func get_distance_to_state(world_states: Dictionary) -> int:
	var distance: int = 0
	for ws_name: StringName in desired_world_states:
		if world_states[ws_name] != desired_world_states[ws_name]:
			distance += 1
	return distance
