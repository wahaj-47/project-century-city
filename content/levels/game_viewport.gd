class_name GameViewport
extends SubViewport

@export var render: Sprite2D

func get_game_mouse_position() -> Vector2:
	var mouse_pos := get_viewport().get_mouse_position()
	return render.to_local(mouse_pos)

func get_mouse_position_in_world_space(world_context: Node3D, ray_length: float = 1000.0) -> Vector3:
	var screen_position := get_game_mouse_position()
	var camera = get_camera_3d()
	
	var origin = camera.project_ray_origin(screen_position)
	var end = origin + camera.project_ray_normal(screen_position) * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var hit = world_context.get_world_3d().direct_space_state.intersect_ray(query)

	if not hit.is_empty():
		return hit.position

	return Vector3.ZERO