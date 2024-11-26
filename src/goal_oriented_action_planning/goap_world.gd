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


class_name GOAPWorld
extends Node


const GLOBAL_WORLD_GROUP: String = "GOAPGlobalWorld"

## If the world is global, every planner will be able to query it when trying to find a state
@export var global: bool = false

var _world_states: Dictionary = {}


func _ready() -> void:
	# Get child states
	for child: Node in get_children():
		if child is GOAPWorldState:
			_world_states[child.name] = child
	
	if global:
		add_to_group(GLOBAL_WORLD_GROUP)


func get_world_state_value(world_state_name: StringName) -> GOAPWorldState:
	return _world_states.get(world_state_name)


func get_complete_state() -> Dictionary:
	var state: Dictionary = {}
	for state_name: StringName in _world_states:
		state[state_name] = _world_states[state_name].get_value()
	return state
