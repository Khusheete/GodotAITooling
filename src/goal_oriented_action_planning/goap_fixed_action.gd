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


@abstract
class_name GOAPFixedAction
extends GOAPAction


@export var preconditions: Dictionary = {}
@export var effects: Dictionary = {}


@abstract
func is_finished() -> bool


@abstract
func get_cost() -> int


@abstract
func _start() -> void


@abstract
func _end() -> void


func can_execute() -> bool:
	return true


func _are_preconditions_met(states: Dictionary) -> bool:
	for precond: StringName in preconditions:
		if preconditions[precond] != states[precond]:
			return false
	return true


func _apply_effects(states: Dictionary) -> void:
	for world_state: StringName in effects:
		states[world_state] = effects[world_state]
