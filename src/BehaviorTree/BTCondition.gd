@icon("../../assets/icons/BTCondition.svg")
## A condition is a sequence that will be executed if and only if the condition is met.
## If it was not met, it will result in a failure.
class_name BTCondition
extends "BTSequence.gd"


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
