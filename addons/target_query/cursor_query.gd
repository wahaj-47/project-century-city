class_name CursorQuery
extends TargetQuery

@export var ray_length := 1000.0
@export_flags_3d_physics var collision_mask := 1
@export var collide_with_bodies := true
@export var collide_with_areas := false

func _init(p_ray_length: float = 1000.0, p_collision_mask: int = 1, p_collide_with_bodies: bool = true, p_collide_with_areas: bool = false):
    ray_length = p_ray_length
    collision_mask = p_collision_mask
    collide_with_bodies = p_collide_with_bodies
    collide_with_areas = p_collide_with_areas

func find_target(context: Node3D) -> Dictionary:
    var viewport = context.get_viewport()
    var camera = viewport.get_camera_3d()
    var screen_position = viewport.get_mouse_position()

    var origin = camera.project_ray_origin(screen_position)
    var end = origin + camera.project_ray_normal(screen_position) * ray_length

    var query = PhysicsRayQueryParameters3D.create(origin, end, collision_mask)
    query.collide_with_bodies = true
    query.collide_with_areas = true

    var space_state := context.get_world_3d().direct_space_state
    return space_state.intersect_ray(query)