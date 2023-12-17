@icon("res://addons/AIT/assets/icons/BTAction.svg")
## Tries to execute some action using the `_tick` function.
## `_tick` will be executed during the BehaviorTree's process thread.
class_name BTAction
extends "BTNode.gd"


enum TickState {
	SUCCESS,
	FAILURE,
	RUNNING
}


func _internal_tick(_child_state: InternalState) -> InternalState:
	match _tick(get_process_delta_time()):
		TickState.SUCCESS:
			return InternalState.SUCCESS
		TickState.RUNNING:
			return InternalState.RUNNING
		TickState.FAILURE, _:
			return InternalState.FAILURE


func _tick(delta: float) -> TickState:
	return TickState.FAILURE
