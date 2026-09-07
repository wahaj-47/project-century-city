@tool
extends BTAction
## PlayerDistance

var player: Character
var map: AStarGridMap
var character: Character

var oldDistance: float = 0

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "PlayerDistance"


# Called each time this task is entered.
func _enter() -> void:
	player = GameState.player
	map = GameState.map
	character = agent as Character

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var newDistance = agent.global_position.distance_to(player.global_position)
	# initial distance calculation or player is moving towards enemy
	if oldDistance ==  0 or oldDistance - newDistance > 0:
		oldDistance = newDistance
		# do not move towards player
		return FAILURE
	# player is moving away from enemy
	else:
		# move towards player
		return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
