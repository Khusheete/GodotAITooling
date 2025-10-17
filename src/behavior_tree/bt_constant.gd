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


## Always return some tick state (either SUCCESS or FAILURE).
class_name BTConstant
extends BTNode
# TODO: create icon


enum TickState {
	SUCCESS,
	FAILURE,
}


@export var returned_tick_state := TickState.SUCCESS


func _reset() -> void:
	pass


func _pretick() -> void:
	pass


func _internal_tick(_p_child_state: InternalState) -> InternalState:
	match returned_tick_state:
		TickState.SUCCESS:
			return InternalState.SUCCESS
		TickState.FAILURE, _:
			return InternalState.FAILURE


func _get_process_child() -> BTNode:
	push_error("Trying to access the child of a BTConstant")
	return self # DEAD CODE
