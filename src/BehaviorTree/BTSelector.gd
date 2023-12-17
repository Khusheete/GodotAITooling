@icon("res://addons/AIT/assets/icons/BTSelector.svg")
## Executes child BTNodes until a success happend.
class_name BTSelector
extends "BTNode.gd"


var next_child: int


func _internal_tick_init() -> void:
	next_child = -1


func _internal_tick(child_state: InternalState) -> InternalState:
	# If the child succeded, stop there
	if child_state == InternalState.SUCCESS:
		return InternalState.SUCCESS
	
	# Otherwise try to continue
	next_child += 1
	if next_child == get_child_count():
		return InternalState.FAILURE
	else:
		return InternalState.CONTINUE


func _get_process_child() -> BTNode:
	return get_child(next_child)
