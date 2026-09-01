@tool
extends BTAction
## MoveToPlayer

@export var player_var: StringName = &"player_node"
@export var map_var: StringName = &"map_node"
@export var step_var: StringName = &"step_to_take"

var player
var map
var parent

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "MoveToPlayer"


# Called once during initialization.
func _setup() -> void:
	pass

# Called each time this task is entered.
func _enter() -> void:
	player = blackboard.get_var(player_var)
	map = blackboard.get_var(map_var)
	parent = agent as Character


# Called each time this task is exited.
func _exit() -> void:
	pass
	

func getPath() -> Array:
	var pos = map.to_grid_coords(parent.global_position)
	var playerPos = map.to_grid_coords(player.global_position)
	return map.get_id_path(pos, playerPos)

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if TurnTracker.turn == TurnTracker.ActorType.ENEMIES:
		var path = getPath()
		if path.size() <= 1:
			TurnTracker.flipTracker()
			return FAILURE
		else:
			var step = Vector3i(path[1].x-path[0].x,0,path[1].y-path[0].y)
			parent.move_on_grid(step)
			TurnTracker.flipTracker()
			return SUCCESS
	else:
		return RUNNING



# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
