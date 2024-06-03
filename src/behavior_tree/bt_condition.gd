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


## A condition is a sequence that will be executed if and only if the condition is met.
## If it was not met, it will result in a failure.
@icon("../../assets/icons/bt_condition.svg")
class_name BTCondition
extends "bt_sequence.gd"


var _condition_checked: bool


func _internal_tick_init() -> void:
	super._internal_tick_init()
	_condition_checked = false


func _internal_tick(child_state: InternalState) -> InternalState:
	if not _condition_checked:
		_condition_checked = true
		if not _condition():
			# If the condition is false, return failure, don't go back through this path
			return InternalState.FAILURE
	
	# If the condition has been checked, it must be true
	return super._internal_tick(child_state)


func _condition() -> bool:
	return false
