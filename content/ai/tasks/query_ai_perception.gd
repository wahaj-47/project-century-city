## QueryAIPerception
@tool
extends BTCondition

@export var target_type: Script

var ai_perception_component: AIPerceptionComponent

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "QueryAIPerception"


# Called once during initialization.
func _setup() -> void:
	var character = agent as Character
	ai_perception_component = character.get_ai_perception_component() if character.has_method("get_ai_perception_component") else null


# Called each time this task is ticked (aka executed).
func _tick(__delta: float) -> Status:
	if ai_perception_component == null:
		return FAILURE

	var query_result = ai_perception_component.has_filtered_entities(
		func(entity) -> bool:
			return is_instance_of(entity, target_type)
	)
	
	if query_result:
		return SUCCESS
	
	return FAILURE


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
