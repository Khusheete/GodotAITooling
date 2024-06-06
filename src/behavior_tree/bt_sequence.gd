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


## Executes all the childs nodes. Stop at the first running one.
## Fails at the first fail.
@icon("../../assets/icons/bt_sequence.svg")
class_name BTSequence
extends "bt_node.gd"



var next_child: int


func _internal_tick_init() -> void:
	next_child = -1


func _internal_tick(child_state: InternalState) -> InternalState:
	# If the child succeded, stop there
	if child_state == InternalState.FAILURE:
		return InternalState.FAILURE
	
	# Otherwise try to continue
	next_child += 1
	if next_child == get_child_count():
		return InternalState.SUCCESS
	else:
		return InternalState.CONTINUE


func _get_process_child() -> BTNode:
	return get_child(next_child)
