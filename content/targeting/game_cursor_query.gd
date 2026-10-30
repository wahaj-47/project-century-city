class_name GameCursorQuery
extends CursorQuery

func find_target(context: Node3D) -> Dictionary:
    var viewport = context.get_viewport() as GameViewport
    if viewport == null: return {}

    var camera = viewport.get_camera_3d()
    var screen_position = viewport.get_game_mouse_position()

    var origin = camera.project_ray_origin(screen_position)
    var end = origin + camera.project_ray_normal(screen_position) * ray_length

    var query = PhysicsRayQueryParameters3D.create(origin, end, collision_mask)
    query.collide_with_bodies = true
    query.collide_with_areas = true

    var space_state := context.get_world_3d().direct_space_state
    return space_state.intersect_ray(query)