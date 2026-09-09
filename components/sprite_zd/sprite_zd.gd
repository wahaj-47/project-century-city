class_name SpriteZD
extends Sprite3D

var camera: Camera3D

enum Direction {
	DOWN,
	DOWN_LEFT,
	LEFT,
	UP_LEFT,
	UP,
	UP_RIGHT,
	RIGHT,
	DOWN_RIGHT,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame_coords.y = Direction.RIGHT
	camera = get_viewport().get_camera_3d()


# # Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_forward = camera.global_transform.basis.z
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x

	var forward_dot = forward.dot(camera_forward)
	var right_dot = right.dot(camera_forward)

	var angle: float = atan2(right_dot, forward_dot)
	frame_coords.y = posmod(roundi((angle + PI) / (PI / 4.0)), 8)
