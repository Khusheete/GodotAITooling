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


## Tries to execute some action using the `_tick` function.
## `_tick` will be executed during the BehaviorTree's process thread.
@icon("../../assets/icons/bt_action.svg")
class_name BTAction
extends "bt_node.gd"


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
