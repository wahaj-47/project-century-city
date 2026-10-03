class_name TexelSnappedCamera
extends Camera3D

@export var enabled := true

@onready var _prev_rotation := global_rotation
@onready var _snap_space := global_transform

var texel_size: float
var texel_error: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if global_rotation != _prev_rotation:
		_prev_rotation = global_rotation
		_snap_space = global_transform
	
	var game_size = get_viewport().size
	texel_size = size / float(game_size.y)
	var snap_space_position := global_position * _snap_space
	var snapped_snap_space_position := snap_space_position.snapped(Vector3.ONE * texel_size)
	var snap_error := snapped_snap_space_position - snap_space_position

	if enabled:
		h_offset = snap_error.x
		v_offset = snap_error.y
		texel_error = Vector2(snap_error.x, -snap_error.y) / texel_size
	else:
		texel_error = Vector2.ZERO

