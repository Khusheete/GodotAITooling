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
extends EditorPlugin


const BEHAVIOR_TREE_ICON: Texture = preload("assets/icons/behavior_tree.svg")
const BT_SEQUENCE_ICON: Texture = preload("assets/icons/bt_sequence.svg")
const BT_SELECTOR_ICON: Texture = preload("assets/icons/bt_selector.svg")
const BT_CONDITION_ICON: Texture = preload("assets/icons/bt_condition.svg")
const BT_ACTION_ICON: Texture = preload("assets/icons/bt_action.svg")
const BT_NODE_ICON: Texture = preload("assets/icons/bt_node.svg")

const FINITE_STATE_MACHINE_ICON: Texture = preload("assets/icons/finite_state_machine.svg")

func _enter_tree() -> void:
	# Finite State Machine types
	add_custom_type(
		"FiniteStateMachine",
		"Node",
		FiniteStateMachine,
		FINITE_STATE_MACHINE_ICON
	)
	add_custom_type(
		"FSMState",
		"Node",
		FSMState,
		null
	)
	
	# Behavior Tree types
	add_custom_type(
		"BehaviorTree",
		"Node",
		BehaviorTree,
		BEHAVIOR_TREE_ICON
	)
	add_custom_type(
		"BTNode",
		"Node",
		BTNode,
		BT_NODE_ICON
	)
	add_custom_type(
		"BTSequence",
		"Node",
		BTSequence,
		BT_SEQUENCE_ICON
	)
	add_custom_type(
		"BTCondition",
		"Node",
		BTCondition,
		BT_CONDITION_ICON
	)
	add_custom_type(
		"BTSelector",
		"Node",
		BTSelector,
		BT_SELECTOR_ICON
	)
	add_custom_type(
		"BTAction",
		"Node",
		BTAction,
		BT_ACTION_ICON
	)


func _exit_tree() -> void:
	# Finite State Machine types
	remove_custom_type("FiniteStateMachine")
	remove_custom_type("FSMState")
	
	# Behavior Tree types
	remove_custom_type("BehaviorTree")
	remove_custom_type("BTNode")
	remove_custom_type("BTSequence")
	remove_custom_type("BTCondition")
	remove_custom_type("BTSelector")
	remove_custom_type("BTAction")
