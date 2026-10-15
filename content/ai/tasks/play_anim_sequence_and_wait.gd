## PlayAnimSequenceAndWait
@tool
extends BTAction

@export var actor: BBNode
@export var animation_name: StringName = ""
@export var speed: float = 1.0
@export var from_end: bool = false
@export var hold_last_frame: bool = false

var _character: Character
var _started: bool = false

# Display a customized name (requires @tool).
func _generate_name() -> String:
	if animation_name == "": return "PlayAnimSequenceAndWait"
	return "Play animation \"" + animation_name + "\" and wait"


# Called each time this task is entered.
func _enter() -> void:
	_character = actor.get_value(scene_root, blackboard)


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if not _started:
		_character.play_anim_montage(animation_name)
		_started = true
		return RUNNING

	if _character.is_montage_playing(): 
		return RUNNING
	
	if hold_last_frame:
		_character.animation_tree.active = false

	return SUCCESS


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if actor == null: warnings.append("Actor is required.")
	if animation_name == "": warnings.append("Animation name is required.")
	return warnings

