@tool
extends BTAction
## FindTarget

@export var output_var: StringName
@export var target_type: Script

var ai_perception_component: AIPerceptionComponent

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "FindTarget"


# Called once during initialization.
func _setup() -> void:
	var character = agent as Enemy
	ai_perception_component = character.get_ai_perception_component()


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var potential_targets = ai_perception_component.get_filtered_entities(
		func(entity) -> bool:
			return is_instance_of(entity, target_type)
	)

	if potential_targets.size() == 0:
		return FAILURE
	
	blackboard.set_var(output_var, potential_targets[0])
	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
