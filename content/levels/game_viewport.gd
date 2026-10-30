class_name GameViewport
extends SubViewport

@export var render: Sprite2D


func get_game_mouse_position() -> Vector2:
	var mouse_pos := get_viewport().get_mouse_position()
	return render.to_local(mouse_pos)
