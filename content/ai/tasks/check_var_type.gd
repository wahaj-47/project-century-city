## CheckVarType
@tool
extends BTCondition

@export var target_var: StringName
@export var target_type: Script

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "CheckVarType"


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var value = blackboard.get_var(target_var);

	if value == null:
		return FAILURE

	if is_instance_of(value, target_type):
		return SUCCESS

	return FAILURE


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
