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

	match direction_dimension:
		DirectionDimension.X: frame_coords.x = index
		DirectionDimension.Y: frame_coords.y = index


func _update_direction_mapping() -> void:
	direction_mapping.clear()

	for i in range(directions):
		var angle := TAU * float(i) / directions

		var direction := Vector2(
			- sin(angle),
			cos(angle)
		)

		direction_mapping[direction] = i
