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
