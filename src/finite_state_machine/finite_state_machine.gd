@tool
@icon("../../assets/icons/finite_state_machine.svg")
class_name FiniteStateMachine
extends Node


## Emitted when the current state was changed.
signal state_changed(from: FSMState, to: FSMState)


## The starting state is the state that this FiniteStateMachine will start on when
## it becomes ready.
@export var starting_state: NodePath: set = set_starting_state

var _set_state_args: Dictionary = {}
@onready var current_state: FSMState = get_node_or_null(starting_state):
	set(value):
		var prev_state: FSMState = current_state
		current_state = value
		emit_signal("state_changed", prev_state, current_state)
	
		if is_inside_tree():
			prev_state.__exit_state(current_state)
			current_state.__enter_state(prev_state, _set_state_args)
			_set_state_args = {}


var enabled: bool = true: set = set_enabled, get = is_enabled


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	current_state.__enter_state(null, {})


func current_state_has_property(property: StringName) -> bool:
	return current_state.has_property(property)


## Gets the state at `state_name` and sets it as the current state.
## `args` are the (optional) arguments to be passed to the new state `_on_enter`.
func change_current_state(state_name: NodePath, args: Dictionary = {}) -> void:
	var state: Node = get_node_or_null(state_name)
	
	if state == null:
		push_error("State [%s] does not exist" % [state_name])
		return
	if not state is FSMState:
		push_error("[%s] is not a state" % [state_name])
		return
	
	set_current_state(state as FSMState, args)


## Sets the current state to `state`.
## `args` are the (optional) arguments to be passed to the new state `_on_enter`.
func set_current_state(state: FSMState, args: Dictionary = {}) -> void:
	_set_state_args = args
	current_state = state


func get_current_state() -> FSMState:
	return current_state


func set_starting_state(path: NodePath) -> void:
	starting_state = path
	if is_inside_tree():
		update_configuration_warnings()


func set_enabled(value: bool) -> void:
	enabled = value
	current_state._set_activated(enabled)


func is_enabled() -> bool:
	return enabled


func enable() -> void:
	set_enabled(true)


func disable() -> void:
	set_enabled(false)


func _get_configuration_warnings() -> PackedStringArray:
	var warns := PackedStringArray([])
	if starting_state.is_empty():
		warns.push_back("There is no starting state.")
	else:
		var start_state: Node = get_node_or_null(starting_state)
		if start_state == null:
			warns.push_back("Starting state does not exist.")
		elif not start_state is FSMState:
			warns.push_back("Starting state path does not point towards a State node.")
	return warns
