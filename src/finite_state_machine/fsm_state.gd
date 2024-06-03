@tool
class_name FSMState
extends Node

## The parent FiniteStateMachine
var _fsm: FiniteStateMachine


## Properties are "flags" that `State`s may have. To know weather the current
## state has a certain property, call the `current_state_has_property` on the
## parent FiniteStateMachine.
##
## A child class can set custom properties by defining a Array[StringName] variable
## named `_custom_state_properties`. Those will be added on_ready when running the game.
##
## For example in a first person shooter, this could be used to tell the player
## controller weather you can use a weapon in the current state (with a property
## named &"can_fire_weapon"). This property would be in the "Walking" State
## and the "Running" State, but maybe not in the "Swimming" State.
@export var state_properties: Array[StringName] = []


func _ready() -> void:
	_set_activated(false)
	
	if Engine.is_editor_hint():
		return
	
	# Add custom state properties
	var cstate_properties = get(&"_custom_state_properties")
	if cstate_properties != null and cstate_properties is Array[StringName]:
		state_properties.append_array(cstate_properties)


func _enter_tree() -> void:
	_find_fsm()
	update_configuration_warnings()


func _find_fsm() -> void:
	var node: Node = get_parent()
	while not node is FiniteStateMachine:
		if node == get_tree().root:
			node = null
			break
		
		if node is FSMState:
			node = node._fsm
			break
		
		node = node.get_parent()
	
	_fsm = node


func __enter_state(from: FSMState, args: Dictionary) -> void:
	_set_activated(true)
	_enter_state(from, args)


func __exit_state(to: FSMState) -> void:
	_set_activated(false)
	_exit_state(to)


func _set_activated(value: bool) -> void:
	set_process(value)
	set_physics_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)
	set_process_unhandled_key_input(value)


func has_property(property: StringName) -> bool:
	return property in state_properties


## Change the current state of the parent `FiniteStateMachine` to the state with
## name `state_name`.
## `args` are the (optional) arguments to be passed to the new state `_on_enter`.
func change_current_state(state_name: NodePath, args: Dictionary = {}) -> void:
	_fsm.change_current_state(state_name, args)


## Set the current state of the parent `FiniteStateMachine` to `state`.
## `args` are the (optional) arguments to be passed to the new state `_on_enter`.
func set_current_state(state: FSMState, args: Dictionary = {}) -> void:
	_fsm.set_current_state(state, args)


func _get_configuration_warnings() -> PackedStringArray:
	var warns := PackedStringArray([])
	if _fsm == null: # No FiniteStateMachine found
		warns.push_back("State is not a child of a FiniteStateMachine")
	return warns


## If overriden, will be called when this state becomes the current state
## `args` are the arguments given for the transition (see `set_current_state`)
func _enter_state(_from: FSMState, _args: Dictionary) -> void:
	pass


## If overriden, will be called when this state is no longer the current state
func _exit_state(_to: FSMState) -> void:
	pass
