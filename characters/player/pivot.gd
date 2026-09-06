extends Marker3D

func _ready() -> void:
	# The pivot does not inherit the owner's transform.
	# This is to prevent the pivot from rotating with the owner.
	top_level = true

func _process(_delta: float) -> void:
	# We still need to follow the owner's position.
	global_position = owner.global_position
