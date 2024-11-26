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


class_name GOAPAction
extends Node


@export var preconditions: Dictionary = {}
@export var effects: Dictionary = {}

var active: bool = false


func _ready() -> void:
	_set_activated(false)


func _are_preconditions_met(states: Dictionary) -> bool:
	for precond: StringName in preconditions:
		if preconditions[precond] != states[precond]:
			return false
	return true


func _apply_effects(states: Dictionary) -> void:
	for world_state: StringName in effects:
		states[world_state] = effects[world_state]


func __start() -> void:
	_set_activated(true)
	_start()


func __end() -> void:
	_set_activated(false)
	_end()


func _set_activated(value: bool) -> void:
	active = value
	set_process(value)
	set_physics_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)
	set_process_unhandled_key_input(value)


func is_active() -> bool:
	return active


## Function to override
func _start() -> void:
	pass


## Function to override
func _end() -> void:
	pass


## Function to override
func can_execute() -> bool:
	return true # Is the action reasonable to consider


## Function to override
func is_finished() -> bool:
	return false


## Function to override
func get_cost() -> int:
	return 1
