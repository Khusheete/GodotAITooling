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


@icon("../../assets/icons/behavior_tree.svg")
class_name BehaviorTree
extends Node


var running_action: BTAction


func _process(_delta: float) -> void:
	# Tell all the nodes that this is a new tick
	for c: BTNode in get_children():
		c.propagate_call(&"_internal_tick_init")
	
	# Tick the BT
	running_action = null
	var current_node: BTNode = get_child(0)
	var next_child: int = 1
	var child_node_state: int = 4 # None
	
	while true:
		var current_node_state: int = current_node._internal_tick(child_node_state)
		
		match current_node_state:
			0, 1: # Failure, Success
				child_node_state = current_node_state
				var node_parent: Node = current_node.get_parent()
				
				# If the parent is this behavior tree, special treatment
				if node_parent == self:
					if next_child == get_child_count() or \
							current_node_state == 1: # Success
						break
					current_node = get_child(next_child)
					next_child += 1
				else:
					current_node = node_parent
			2: # Running
				running_action = current_node
				break
			3: # Continue
				current_node = current_node._get_process_child()
			_:
				push_error("Error, unreachable state")
				break
