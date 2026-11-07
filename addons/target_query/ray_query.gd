@tool
class_name RayQuery
extends TargetQuery

@export var target_position := Vector3.FORWARD
@export var relative_to_owner := true
@export_flags_3d_physics var collision_mask := 1
@export var exclude_self := true
@export var collide_with_bodies := true
@export var collide_with_areas := false


func _init(p_target_position: Vector3 = Vector3.FORWARD, p_collision_mask: int = 1, p_exclude_self: bool = true, p_collide_with_bodies: bool = true, p_collide_with_areas: bool = false):
	target_position = p_target_position
	collision_mask = p_collision_mask
	exclude_self = p_exclude_self
	collide_with_bodies = p_collide_with_bodies
	collide_with_areas = p_collide_with_areas


func find_target(context: Node3D) -> Dictionary:
	var from := context.global_position
	var to := target_position

	if relative_to_owner:
		to = context.to_global(target_position)
		
	DebugDraw3D.draw_line(from, to, Color.RED, 0.2)

	var exclude := [context] if exclude_self else []
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask, exclude)
	
	query.collide_with_bodies = collide_with_bodies
	query.collide_with_areas = collide_with_areas
		
	var space_state := context.get_world_3d().direct_space_state
	return space_state.intersect_ray(query)
