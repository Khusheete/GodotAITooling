# Copyright (c) 2025 Souchet Ferdinand (@Khusheete)
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


@tool
@icon("../../assets/icons/bt_node.svg")
@abstract
class_name BTNode
extends Node


enum InternalState {
	FAILURE  = 0,
	SUCCESS  = 1,
	RUNNING  = 2,
	CONTINUE = 3,
	NONE     = 4
}

enum _VisitedState {
	## The state of the node right before a tick if it has been visited last tick.
	PRETICK = 0,
	## The state of the node after it has been visited.
	VISITED = 1,
	## The state of the node if it has not been visited last tick.
	IDLE = 2,
}


var behavior_tree: BehaviorTree = null
var _visited_state: _VisitedState = _VisitedState.PRETICK
var _first_visit: bool = true


func is_first_visit() -> bool:
	return _first_visit


func is_idle() -> bool:
	return _visited_state == _VisitedState.IDLE


func _enter_tree() -> void:
	_update_bt()
	update_configuration_warnings()


func _notification(p_what: int) -> void:
	if p_what == NOTIFICATION_PARENTED:
		_update_bt()
		update_configuration_warnings()


func _update_bt() -> void:
	var parent: Node = get_parent()
	if parent is BehaviorTree:
		behavior_tree = parent
	elif parent is BTNode:
		behavior_tree = parent.behavior_tree


func __pretick() -> void:
	if _visited_state == _VisitedState.PRETICK:
		_reset()
		_visited_state = _VisitedState.IDLE
		_first_visit = true
	if _visited_state == _VisitedState.VISITED:
		_visited_state = _VisitedState.PRETICK
	_pretick()


func __internal_tick(p_child_state: int) -> int:
	_visited_state = _VisitedState.VISITED
	var result: int = _internal_tick(p_child_state)
	_first_visit = false
	return result


## This function is called when a tick is about to take place, and that this
## node has not been visited during the previous tick.
@abstract
func _reset() -> void;


## This function is called when a tick is about to take place.
@abstract
func _pretick() -> void;


## Should return one of [InternalState]
@abstract
func _internal_tick(p_child_state: int) -> int;


## Tells the behavior tree which (child) node should be visited next
@abstract
func _get_process_child() -> BTNode;


func _get_configuration_warnings() -> PackedStringArray:
	var warns := PackedStringArray()
	if behavior_tree == null:
		warns.push_back("BTNode should have a BehaviorTree as ancestor.")
	return warns
