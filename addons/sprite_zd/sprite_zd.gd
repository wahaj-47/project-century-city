@tool
class_name SpriteZD
extends Sprite3D

## The dimension on your spritesheet that represents the directionality of the sprite.
enum DirectionDimension {
	X,
	Y,
}

@export var direction_dimension: DirectionDimension = DirectionDimension.Y
@export_range(4, 8, 4) var directions: int = 8:
	set(value):
		directions = value
		_update_direction_mapping()

## A mapping of directions to their corresponding frames.
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var direction_mapping: Dictionary[Vector2, int]

var facing: Vector2 = Vector2(0, 1)
var root_motion: Vector3 = Vector3.ZERO:
	set(value):
		var delta := value - root_motion
		delta.z = -delta.z
		root_motion = value
		position += delta


func _ready() -> void:
	_update_direction_mapping()

	
func set_directionality(direction: Vector2) -> void:
	if direction.is_zero_approx(): return

	# angle() returns radians, 0 = pointing right (+X), increasing clockwise in screen space
	var angle := direction.angle()

	# offset so index 0 (up, i.e. angle -PI/2) lands on a bucket center,
	# and wrap into [0, TAU)
	var adjusted := wrapf(angle - (PI / 2.0) + (TAU / directions) / 2.0, 0.0, TAU)
	var index := int(adjusted / (TAU / directions))

	facing = index_to_direction(index)

	match direction_dimension:
		DirectionDimension.X: frame_coords.x = index
		DirectionDimension.Y: frame_coords.y = index


func _update_direction_mapping() -> void:
	direction_mapping.clear()

	for i in range(directions):
		var direction := index_to_direction(i)
		direction_mapping[direction] = i


func index_to_direction(index: int) -> Vector2:
	var a := TAU * float(index) / directions
	return Vector2(
		- sin(a),
		cos(a)
	)