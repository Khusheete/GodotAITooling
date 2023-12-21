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

var _is_running: bool = false
var first_tick: bool = false


func _internal_tick_init() -> void:
	if not _is_running:
		first_tick = true
	_is_running = false


func _internal_tick(_child_state: InternalState) -> InternalState:
	_is_running = true
	var tick_state: TickState = _tick(get_process_delta_time())
	first_tick = false
	match tick_state:
		TickState.SUCCESS:
			return InternalState.SUCCESS
		TickState.RUNNING:
			return InternalState.RUNNING
		TickState.FAILURE, _:
			return InternalState.FAILURE


func _tick(delta: float) -> TickState:
	return TickState.FAILURE


func is_first_tick() -> bool:
	return first_tick
