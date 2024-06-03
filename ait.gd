@tool
extends EditorPlugin


const BEHAVIOR_TREE_ICON: Texture = preload("assets/icons/behavior_tree.svg")
const BT_SEQUENCE_ICON: Texture = preload("assets/icons/bt_sequence.svg")
const BT_SELECTOR_ICON: Texture = preload("assets/icons/bt_selector.svg")
const BT_CONDITION_ICON: Texture = preload("assets/icons/bt_condition.svg")
const BT_ACTION_ICON: Texture = preload("assets/icons/bt_action.svg")
const BT_NODE_ICON: Texture = preload("assets/icons/bt_node.svg")

const FINITE_STATE_MACHINE_ICON: Texture = preload("assets/icons/finite_state_machine.svg")

func _enter_tree() -> void:
	# Finite State Machine types
	add_custom_type(
		"FiniteStateMachine",
		"Node",
		FiniteStateMachine,
		FINITE_STATE_MACHINE_ICON
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
		BEHAVIOR_TREE_ICON
	)
	add_custom_type(
		"BTNode",
		"Node",
		BTNode,
		BT_NODE_ICON
	)
	add_custom_type(
		"BTSequence",
		"Node",
		BTSequence,
		BT_SEQUENCE_ICON
	)
	add_custom_type(
		"BTCondition",
		"Node",
		BTCondition,
		BT_CONDITION_ICON
	)
	add_custom_type(
		"BTSelector",
		"Node",
		BTSelector,
		BT_SELECTOR_ICON
	)
	add_custom_type(
		"BTAction",
		"Node",
		BTAction,
		BT_ACTION_ICON
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
