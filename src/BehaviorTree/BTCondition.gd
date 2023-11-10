@icon("res://addons/AIT/assets/icons/BTCondition.svg")
extends "BTSequence.gd"


var _condition_checked: bool


func _internal_tick_init() -> void:
	super._internal_tick_init()
	_condition_checked = false


func _internal_tick(child_state: InternalState) -> InternalState:
	if not _condition_checked:
		_condition_checked = true
		if not _condition():
			# If the condition is false, return success, don't go back through this path
			return InternalState.SUCCESS
	
	# If the condition has been checked, it must be true
	return super._internal_tick(child_state)


func _condition() -> bool:
	return false
