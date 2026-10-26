extends GameplayCueNotify

@export var decal: Decal
@export_flags_3d_physics var collision_mask: int = 1
@export var ray_length: float = 20.0

func play_cue(parameters: GameplayCueParameters) -> void:
	decal.global_position = parameters.location

	var space_state := decal.get_world_3d().direct_space_state

	var query := PhysicsRayQueryParameters3D.create(
		decal.global_position,
		decal.global_position + Vector3.DOWN * ray_length,
		collision_mask
	)

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return

	decal.global_position = result.position + result.normal * 0.02
