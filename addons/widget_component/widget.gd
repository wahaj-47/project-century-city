@tool
class_name Widget
extends Resource

@export var scene: PackedScene
@export var data: Variant

func _init(p_scene: PackedScene = null, p_data: Variant = null, ) -> void:
	scene = p_scene
	data = p_data

func instantiate() -> Node:
	var widget := scene.instantiate()

	if data != null and widget.has_method("initialize"):
		widget.initialize(data)

	return widget
