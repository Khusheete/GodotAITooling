# Copyright (c) 2024 Souchet Ferdinand (@Khusheete)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


class_name GOAPPlanner
extends Agent


enum GoalState {
	## This goal was not considered by the planner
	NOT_CONSIDERED,
	## This goal is invalid: it cannot be met
	INVALID,
	## This goal is already met
	MET,
	## This is the goal the planner currently wants to achieve
	CURRENT,
	## This is the current goal, but it is met. Actions that lead to this goal are yet to be
	## finished and no other goal is of higher priority.
	CURRENT_MET,
}

const INT_INF: int = (1 << 63) - 1

## The world local to the agent
@export var local_world: GOAPWorld
## If this is true, debug information from the plan making process will be saved
@export var keep_debug_information: bool = false

var goals: Array[GOAPGoal] = []
var actions: Array[GOAPAction] = []

var current_goal: GOAPGoal = null
var plan: Array[GOAPAction] = []
var current_action: int = -2

var _debug_goal_state: Array[GoalState] = []


func _ready() -> void:
	super()
	# Get goals and actions
	var nodes_to_check: Array[Node] = get_children()
	while not nodes_to_check.is_empty():
		var node: Node = nodes_to_check.pop_back()
		if node is GOAPGoal:
			goals.push_back(node)
		if node is GOAPAction:
			node.planner = self # Set the node's planner to self
			actions.push_back(node)
		nodes_to_check.append_array(node.get_children())
	
	# Sort goals by priority
	goals.sort_custom(func(a: GOAPGoal, b: GOAPGoal): return a.priority > b.priority)
	
	# Setup debug info
	_debug_goal_state.resize(goals.size())
	for i: int in _debug_goal_state.size():
		_debug_goal_state[i] = GoalState.NOT_CONSIDERED


func tick() -> void:
	var current_state: Dictionary = get_current_world_state()
	
	if has_plan():
		var action: GOAPAction = get_current_action()
		if action.is_finished():
			_next_action(current_state)
		elif not action.can_execute() or not is_action_valid(action, current_state):
			# The action is not valid anymore, discard the plan
			invalidate_current_plan()
	
	if has_plan():
		return # We still have a plan stick to it
	
	# Otherwise find a new plan
	var current_goal_met: bool = false
	
	if keep_debug_information:
		for i: int in _debug_goal_state.size():
			_debug_goal_state[i] = GoalState.NOT_CONSIDERED
	
	for i: int in goals.size():
		var goal: GOAPGoal = goals[i]
		
		if not goal.is_valid():
			_debug_goal_state[i] = GoalState.INVALID
			continue
		if has_plan() and goal == current_goal:
			if keep_debug_information:
				if is_goal_met(current_goal, current_state):
					_debug_goal_state[i] = GoalState.CURRENT_MET
				else:
					_debug_goal_state[i] = GoalState.CURRENT
			break # The next goals are lower priority
		if is_goal_met(goal, current_state):
			if keep_debug_information:
				_debug_goal_state[i] = GoalState.MET
			continue
		
		var new_plan: Array[GOAPAction] = find_plan(goal, current_state)
		if not new_plan.is_empty():
			if has_plan():
				plan[current_action].__end()
			plan = new_plan
			current_goal = goal
			current_action = 0
			plan[current_action].__start()
			break


func find_plan(goal: GOAPGoal, current_state: Dictionary) -> Array[GOAPAction]:
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


func _next_action(current_state: Dictionary) -> void:
	plan[current_action].__end()
	current_action += 1
	if current_action < 0 or current_action >= plan.size() or not plan[current_action]._are_preconditions_met(current_state):
		current_action = -2 # We no longer have a plan
	else:
		plan[current_action].__start()


func invalidate_current_plan() -> void:
	if not has_plan():
		return
	plan[current_action].__end()
	current_action = -2


func get_current_action_index() -> int:
	return current_action


func get_planned_action(index: int) -> GOAPAction:
	return plan[index]


func get_plan_size() -> int:
	return plan.size()


func get_goal_state(index: int) -> GoalState:
	if not keep_debug_information:
		push_warning("Requesting debug information from GOAPPlanner with debug disabled")
		return GoalState.INVALID
	return _debug_goal_state[index]


func get_goal(index: int) -> GOAPGoal:
	return goals[index]


func get_goal_count() -> int:
	return goals.size()


func get_current_action() -> GOAPAction:
	if not has_plan():
		return null
	return plan[current_action]


func has_plan() -> bool:
	return current_action != -2


func is_action_valid(action: GOAPAction, current_state: Dictionary) -> bool:
	return action.can_execute() and action._are_preconditions_met(current_state)


func is_goal_met(goal: GOAPGoal, current_state: Dictionary) -> bool:
	return goal.get_distance_to_state(current_state) == 0


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


func get_local_world_state() -> Dictionary:
	if is_instance_valid(local_world):
		return local_world.get_complete_state()
	return {}


func get_global_world_state() -> Dictionary:
	var current_world_state: Dictionary = {}
	for global_world: GOAPWorld in get_tree().get_nodes_in_group(GOAPWorld.GLOBAL_WORLD_GROUP):
		current_world_state.merge(global_world.get_complete_state())
	return current_world_state


func get_current_world_state() -> Dictionary:
	var current_world_state: Dictionary = get_local_world_state()
	current_world_state.merge(get_global_world_state(), false)
	return current_world_state
