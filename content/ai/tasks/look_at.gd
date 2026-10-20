## LookAt
@tool
extends BTAction

@export var actor: BBNode
@export var target: BBNode

var _character: Character
var _target: Node3D

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Look At"


# Called once during initialization.
func _enter() -> void:
	_character = actor.get_value(scene_root, blackboard)
	_target = target.get_value(scene_root, blackboard)


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	_character.apply_rotation(_target.global_position)
	return SUCCESS

# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
