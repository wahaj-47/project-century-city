# MoveTo
@tool
extends BTAction

@export var target_var: StringName = &"target"
var character: Character

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "MoveTo"

# Called once during initialization.
func _enter() -> void:
	character = agent as Character

func find_path() -> Array[Vector2i]:
	var map = GameState.map
	var target: Character = blackboard.get_var(target_var)
	return map.get_id_path(character.global_position, target.global_position)

# Called each time this task is ticked (aka executed).
func _tick(__delta: float) -> Status:
	var path: Array[Vector2i] = find_path()
	if path.size() <= 1:
		return FAILURE

	var step: Vector2i = path[1] - path[0]
	var direction: Vector3i = Vector3i(step.x, 0, step.y)

	# This means the character is blocked.
	# @TODO: Different status codes for blocked and no path.
	#        We need to be able to distinguish between being blocked by environment or another character
	#        If blocked by character, we kill the character.
	#        If blocked by environment, we can move around it.	
	if not character.apply_movement(direction):
		return FAILURE

	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
