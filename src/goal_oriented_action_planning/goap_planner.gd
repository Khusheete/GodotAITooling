class_name GOAPPlanner
extends Node


const INT_INF: int = (1 << 63) - 1

@export var local_world: GOAPWorld

var goals: Array[GOAPGoal] = []
var actions: Array[GOAPAction] = []

var current_goal: GOAPGoal = null
var plan: Array[GOAPAction] = []
var current_action: int = -2


func _ready() -> void:
	# Get goals and actions
	var nodes_to_check: Array[Node] = get_children()
	while not nodes_to_check.is_empty():
		var node: Node = nodes_to_check.pop_back()
		if node is GOAPGoal:
			goals.push_back(node)
		if node is GOAPAction:
			actions.push_back(node)
		nodes_to_check.append_array(node.get_children())
	
	# Sort goals by priority
	goals.sort_custom(func(a: GOAPGoal, b: GOAPGoal): return a.priority > b.priority)


func _process(_delta: float) -> void:
	if has_plan():
		var action: GOAPAction = get_current_action()
		if action.is_finished():
			next_action()
		if not action.can_execute() or not is_action_valid(action):
			# The action is not valid anymore, discard the plan
			current_action = -2
			action.__end()
	
	# Get a goal and find a plan
	var current_state: Dictionary = get_current_world_state()
	
	for goal: GOAPGoal in goals:
		if not goal.is_valid():
			continue
		if is_goal_met(goal):
			continue
		if has_plan() and goal.priority <= current_goal.priority:
			continue
		
		var new_plan = find_plan(goal, current_state)
		if not new_plan.is_empty():
			if has_plan():
				plan[current_action].__end()
			plan = new_plan
			current_goal = goal
			current_action = 0
			plan[current_action].__start()
			break


func find_plan(goal: GOAPGoal, current_state: Dictionary) -> Array[GOAPAction]:
	# TODO: debug
	var discovered_nodes := AITPriorityQueue.new(true) # Create a min-queue
	discovered_nodes.insert(current_state, 0)
	
	var state_source: Dictionary = {}
	var best_path_cost: Dictionary = {current_state: 0}
	var exploring_state: Dictionary
	var found_path: bool = false
	
	# Find path
	while not discovered_nodes.is_empty():
		exploring_state = discovered_nodes.pop()
		
		var goal_distance: int = goal.get_distance_to_state(exploring_state)
		if goal_distance == 0:
			found_path = true
			break
		
		var current_path_cost: int = best_path_cost[exploring_state]
		
		for action: GOAPAction in actions:
			if not action.can_execute() or not action._are_preconditions_met(exploring_state):
				continue # Action is not possible to do during that state
			
			var neighbour: Dictionary = exploring_state.duplicate()
			action._apply_effects(neighbour)
			
			var cost: int = current_path_cost + action.get_cost()
			if cost < best_path_cost.get(neighbour, INT_INF):
				state_source[neighbour] = [action, exploring_state]
				best_path_cost[neighbour] = cost
				var estimated_distance: int = cost + goal.get_distance_to_state(neighbour)
				if discovered_nodes.contains(neighbour):
					discovered_nodes.set_priority(neighbour, estimated_distance)
				else:
					discovered_nodes.insert(neighbour, estimated_distance)
	
	if not found_path:
		return []
	
	# Construct path
	var path: Array[GOAPAction] = []
	
	while exploring_state in state_source:
		var came_from: Array = state_source[exploring_state]
		var action: GOAPAction = came_from[0]
		path.push_back(action)
		exploring_state = came_from[1]
	
	path.reverse()
	return path


func next_action() -> void:
	plan[current_action].__end()
	current_action += 1
	if current_action < 0 or current_action >= plan.size() or not is_action_valid(get_current_action()):
		current_action = -2 # We no longer have a plan
	else:
		plan[current_action].__start()


func get_current_action() -> GOAPAction:
	if not has_plan():
		return null
	return plan[current_action]


func has_plan() -> bool:
	return current_action != -2


func is_action_valid(action: GOAPAction) -> bool:
	return action.can_execute() and are_world_states_verified(action.preconditions)


func is_goal_met(goal: GOAPGoal) -> bool:
	return are_world_states_verified(goal.desired_world_states)


func are_world_states_verified(desired_world_states: Dictionary) -> bool:
	for world_state_name: StringName in desired_world_states:
		var world_state: GOAPWorldState = get_world_state_value(world_state_name)
		if not is_instance_valid(world_state):
			push_error("[AIT] GOAPWorldState %s does not exist" % world_state_name)
			return false
		if world_state.get_value() != desired_world_states[world_state_name]:
			return false
	return true


func get_world_state_value(world_state_name: StringName) -> GOAPWorldState:
	# Search the local world
	if is_instance_valid(local_world):
		var world_state: GOAPWorldState = local_world.get_world_state_value(world_state_name)
		if is_instance_valid(world_state):
			return world_state
	
	# Search in the global worlds
	for global_world: GOAPWorld in get_tree().get_nodes_in_group(GOAPWorld.GLOBAL_WORLD_GROUP):
		var world_state: GOAPWorldState = global_world.get_world_state_value(world_state_name)
		if is_instance_valid(world_state):
			return world_state
	
	return null


func get_current_world_state() -> Dictionary:
	var current_world_state: Dictionary = {}
	
	if is_instance_valid(local_world):
		current_world_state.merge(local_world.get_complete_state(), false)
	
	# Search in the global worlds
	for global_world: GOAPWorld in get_tree().get_nodes_in_group(GOAPWorld.GLOBAL_WORLD_GROUP):
		current_world_state.merge(global_world.get_complete_state())
	
	return current_world_state
