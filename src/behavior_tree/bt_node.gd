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
