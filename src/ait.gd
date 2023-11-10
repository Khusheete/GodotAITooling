@tool
extends EditorPlugin


const BehaviorTreeIcon: Texture = preload("res://addons/AIT/assets/icons/BehaviorTree.svg")
const BTSequenceIcon: Texture = preload("res://addons/AIT/assets/icons/BTSequence.svg")
const BTSelectorIcon: Texture = preload("res://addons/AIT/assets/icons/BTSelector.svg")
const BTConditionIcon: Texture = preload("res://addons/AIT/assets/icons/BTCondition.svg")
const BTActionIcon: Texture = preload("res://addons/AIT/assets/icons/BTAction.svg")
const BTNodeIcon: Texture = preload("res://addons/AIT/assets/icons/BTNode.svg")

const BehaviorTree: Script = preload("res://addons/AIT/src/BehaviorTree/BehaviorTree.gd")
const BTNode: Script = preload("res://addons/AIT/src/BehaviorTree/BTNode.gd")
const BTSequence: Script = preload("res://addons/AIT/src/BehaviorTree/BTSequence.gd")
const BTAction: Script = preload("res://addons/AIT/src/BehaviorTree/BTAction.gd")
const BTSelector: Script = preload("res://addons/AIT/src/BehaviorTree/BTSelector.gd")
const BTCondition: Script = preload("res://addons/AIT/src/BehaviorTree/BTCondition.gd")


func _enter_tree() -> void:
	# Finite State Machine types
	add_custom_type(
		"FiniteStateMachine",
		"Node",
		FiniteStateMachine,
		null
	)
	add_custom_type(
		"FSMState",
		"Node",
		FSMState,
		null
	)
	
	# Behavior Tree types
	add_custom_type(
		"BehaviorTree",
		"Node",
		BehaviorTree,
		BehaviorTreeIcon
	)
	add_custom_type(
		"BTNode",
		"Node",
		BTNode,
		BTNodeIcon
	)
	add_custom_type(
		"BTSequence",
		"Node",
		BTSequence,
		BTSequenceIcon
	)
	add_custom_type(
		"BTCondition",
		"Node",
		BTCondition,
		BTConditionIcon
	)
	add_custom_type(
		"BTSelector",
		"Node",
		BTSelector,
		BTSelectorIcon
	)
	add_custom_type(
		"BTAction",
		"Node",
		BTAction,
		BTActionIcon
	)


func _exit_tree() -> void:
	# Finite State Machine types
	remove_custom_type("FiniteStateMachine")
	remove_custom_type("FSMState")
	
	# Behavior Tree types
	remove_custom_type("BehaviorTree")
	remove_custom_type("BTNode")
	remove_custom_type("BTSequence")
	remove_custom_type("BTCondition")
	remove_custom_type("BTSelector")
	remove_custom_type("BTAction")
