# MoveToPosition
@tool
extends BTAction

@export var actor: BBNode
@export var target_position: BBVector3
@export var check_collision: bool = true

var _actor: Character
var _target: Vector3


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Move To Position"


# Called once during initialization.
func _enter() -> void:
	_actor = actor.get_value(scene_root, blackboard)
	_target = target_position.get_value(scene_root, blackboard)


# Called each time this task is ticked (aka executed).
func _tick(__delta: float) -> Status:
	if _actor == null:
		push_error("Actor must be a Character.")
		return FAILURE

	if _target == null:
		push_error("Target not found.")
		return FAILURE
	
	# This means the character is blocked.
	# @TODO: Different status codes for blocked and no path.
	#        We need to be able to distinguish between being blocked by environment or another character
	#        If blocked by character, we kill the character.
	#        If blocked by environment, we can move around it.	
	if not _actor.apply_movement(_target, check_collision):
		return FAILURE

	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings	
