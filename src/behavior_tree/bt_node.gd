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


@tool
@icon("../../assets/icons/bt_node.svg")
class_name BTNode
extends Node

var behavior_tree: BehaviorTree = null


func _enter_tree() -> void:
	_update_bt()
	update_configuration_warnings()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		_update_bt()
		update_configuration_warnings()


func _update_bt() -> void:
	var parent: Node = get_parent()
	if parent is BehaviorTree:
		behavior_tree = parent
	elif parent is BTNode:
		behavior_tree = parent.behavior_tree


enum InternalState {
	FAILURE  = 0,
	SUCCESS  = 1,
	RUNNING  = 2,
	CONTINUE = 3,
	NONE     = 4
}


func _internal_tick_init() -> void:
	pass


func _internal_tick(child_state: int) -> int:
	return InternalState.FAILURE


func _get_process_child() -> BTNode:
	return self


func _get_configuration_warnings() -> PackedStringArray:
	var warns := PackedStringArray()
	if behavior_tree == null:
		warns.push_back("BTNode should have a BehaviorTree as ancestor.")
	return warns
