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


## A condition is a sequence that will be executed if and only if the condition is met.
## If it was not met, it will result in a failure.
@icon("../../assets/icons/bt_condition.svg")
@abstract
class_name BTCondition
extends BTSequence


var _condition_checked: bool
var _condition_value: bool


## Returns the value of the condition of this node. Note that for optimisation reasons
## the truth value of the condition is assumed not to change during a tick.
@abstract
func _condition_met() -> bool;


func _pretick() -> void:
	super._pretick()
	_condition_checked = false


func _internal_tick(p_child_state: InternalState) -> InternalState:
	if not _condition_checked:
		_condition_checked = true
		_condition_value = _condition_met()
	
	if _condition_value:
		return super._internal_tick(p_child_state)
	
	reset_sequence()
	return InternalState.FAILURE
