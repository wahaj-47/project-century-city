@tool
extends EditorInspectorPlugin

const DirectionWheelControl = preload("res://addons/sprite_zd/direction_wheel.gd")


func _can_handle(object: Object) -> bool:
	return object is SpriteZD


func _parse_property(object: Object, type: int, name: String, hint_type: int, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "direction_mapping":
		var wheel := DirectionWheelControl.new()
		wheel.setup(object as SpriteZD)
		add_custom_control(wheel)
		return true
	return false
