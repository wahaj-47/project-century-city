## MoveToActor
@tool
extends BTAction

@export var actor: BBNode
@export var target_actor: BBVariant
@export var check_collision: bool = true
@export var max_steps: BBVariant

var _actor: Character
var _target: Node3D
var _map: AStarGridMap
var _max_steps := 0
var _steps := 1
var _path: PackedVector3Array


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Move To Actor"


# Called once during initialization.
func _enter() -> void:
	_steps = 1
	_actor = actor.get_value(scene_root, blackboard)
	_target = target_actor.get_value(scene_root, blackboard)
	_map = blackboard.get_var("map")
	_path = _map.get_world_path(_actor.global_position, _target.global_position)
	_max_steps = min(max_steps.get_value(scene_root, blackboard), _path.size() - 1)

	_actor.apply_movement(_path[_steps], check_collision, _on_movement_finished)


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:

	if _actor == null:
		push_error("Actor must be a Character.")
		return FAILURE

	if _target == null:
		push_error("Target not found.")
		return FAILURE

	if _path.size() <= 1:
		push_error("Path not found")
		return FAILURE

	if _steps >= _max_steps and not _actor.is_moving:
		return SUCCESS

	return RUNNING
	

# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings


func _on_movement_finished() -> void:
	_steps += 1

	if _steps > _max_steps: return 
	
	_actor.apply_movement(_path[_steps], check_collision, _on_movement_finished)
