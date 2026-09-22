## PlayerDistance
@tool
extends BTAction

@export var to_var: StringName
@export var output_var: StringName

var map: AStarGridMap
var character: Enemy

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "FindDistance"


# Called each time this task is entered.
func _enter() -> void:
	map = GameState.map
	character = agent as Enemy


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var entity = blackboard.get_var(to_var)
	if entity == null:
		return FAILURE
		
	var distance = map.distance_to(agent.global_position, entity.global_position)

	blackboard.set_var(output_var, distance)
	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
