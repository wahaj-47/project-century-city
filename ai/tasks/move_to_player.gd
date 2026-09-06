@tool
extends BTAction
## MoveToPlayer

var player: Character
var map: AStarGridMap
var character: Character

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "MoveToPlayer"

# Called once during initialization.
func _enter() -> void:
	player = GameState.player
	map = GameState.map
	character = agent as Character

func find_path() -> Array[Vector2i]:
	return map.get_id_path(character.global_position, player.global_position)

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
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
