## MoveToActor
@tool
extends BTAction

@export var actor: BBNode
@export var target_actor: BBNode
@export var offset: Vector3
@export var check_collision: bool = true
@export var max_steps: int = 1

var _actor: Character
var _target: Node3D
var _map: AStarGridMap
var _steps := 0


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Move To Actor"


# Called once during initialization.
func _enter() -> void:
	_actor = actor.get_value(scene_root, blackboard)
	_target = target_actor.get_value(scene_root, blackboard)
	_map = blackboard.get_var("map")
	_steps = 0


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if _actor == null:
		push_error("Actor must be a Character.")
		return FAILURE

	if _target == null:
		push_error("Target not found.")
		return FAILURE

	if _steps >= max_steps:
		return SUCCESS

	var path = _map.get_id_path(_actor.global_position, _target.global_position)
	
	if path.size() <= 1:
		return FAILURE

	var target_position = _map.to_world_coords(path[1])
	target_position.y = _actor.global_position.y

	var direction = target_position - _actor.global_position
	var _offset = offset.rotated(Vector3.UP, atan2(direction.x, direction.z))

	if not _actor.apply_movement(target_position + _offset, check_collision):
		return FAILURE

	_steps += 1
	return RUNNING


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings

