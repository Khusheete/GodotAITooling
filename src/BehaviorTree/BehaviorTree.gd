@icon("res://addons/AIT/assets/icons/BehaviorTree.svg")
class_name BehaviorTree
extends Node


const BTNode: Script = preload("res://addons/AIT/src/BehaviorTree/BTNode.gd")
const BTAction: Script = preload("res://addons/AIT/src/BehaviorTree/BTAction.gd")


var running_node: BTAction


func _process(_delta: float) -> void:
	# Tell all the nodes that this is a new tick
	for c: BTNode in get_children():
		c.propagate_call(&"_internal_tick_init")
	
	# Tick the BT
	running_node = null
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
				running_node = current_node
				break
			3: # Continue
				current_node = current_node._get_process_child()
			_:
				push_error("Error, unreachable state")
				break
