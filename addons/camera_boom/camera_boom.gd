extends Marker3D

@export var follow_target: Node3D
@export var use_pawn_control_rotation: bool = false

func _ready() -> void:
	if owner == null: set_owner(follow_target)
	# The pivot does not inherit the owner's transform.
	# This is to prevent the pivot from rotating with the owner.
	top_level = not use_pawn_control_rotation

func _process(__delta: float) -> void:
	if owner == null: return
	# We still need to follow the owner's position.
	global_position = follow_target.global_position
