class_name TexelSnappedCamera
extends Camera3D

@export var enabled := true
@export var snap_group := "Snapped"

@onready var _prev_rotation := global_rotation
@onready var snap_space := global_transform

var texel_size: float
var texel_error: Vector2
var _snap_nodes: Array[Node]
var _pre_snapped_positions: Array[Vector3]	


func _ready() -> void:
	RenderingServer.frame_post_draw.connect(_snap_objects_revert)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if global_rotation != _prev_rotation:
		_prev_rotation = global_rotation
		snap_space = global_transform
	
	var game_size = get_viewport().size
	texel_size = size / float(game_size.y)
	var snap_space_position := global_position * snap_space
	var snapped_snap_space_position := snap_space_position.snapped(Vector3.ONE * texel_size)
	var snap_error := snapped_snap_space_position - snap_space_position

	if enabled:
		h_offset = snap_error.x
		v_offset = snap_error.y
		texel_error = Vector2(snap_error.x, -snap_error.y) / texel_size
		_snap_objects.call_deferred()
	else:
		texel_error = Vector2.ZERO


func _snap_objects() -> void:
	_snap_nodes = get_tree().get_nodes_in_group(snap_group)
	_pre_snapped_positions.resize(_snap_nodes.size())
	for i in _snap_nodes.size():
		var node := _snap_nodes[i] as Node3D
		var pos := node.global_position
		_pre_snapped_positions[i] = pos
		var snap_space_pos = pos * snap_space
		var snapped_snap_space_pos = snap_space_pos.snapped(Vector3(texel_size, texel_size, 0.0))
		node.global_position = snap_space * snapped_snap_space_pos


func _snap_objects_revert() -> void:
	for i in _snap_nodes.size():
		(_snap_nodes[i] as Node3D).global_position = _pre_snapped_positions[i]
	_snap_nodes.clear()