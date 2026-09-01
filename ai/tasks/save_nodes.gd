@tool
extends BTAction
class_name saveNodes
## NewTask

@export var player_var: StringName = &"player_node"
@export var map_var: StringName = &"map_node"

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "saveNodes"


# Called each time this task is entered.
func _enter() -> void:
	blackboard.set_var(player_var, agent.get_tree().get_first_node_in_group("Player"))
	blackboard.set_var(map_var, agent.get_tree().get_first_node_in_group("Map"))


# Called each time this task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
