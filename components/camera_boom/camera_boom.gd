extends Marker3D

@export var use_pawn_control_rotation: bool = false

func _ready() -> void:
	# The pivot does not inherit the owner's transform.
	# This is to prevent the pivot from rotating with the owner.
	top_level = not use_pawn_control_rotation

func _process(_delta: float) -> void:
	# We still need to follow the owner's position.
	global_position = owner.global_position
