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
		direction_mapping.clear()

		for i in range(directions):
			var angle := TAU * float(i) / directions

			var direction := Vector2i(
				- roundi(sin(angle)),
				- roundi(cos(angle))
			)

			direction_mapping[direction] = i

## A mapping of directions to their corresponding frames.
@export var direction_mapping: Dictionary[Vector2i, int] = {
	Vector2i(0, -1): 0,
	Vector2i(-1, -1): 1,
	Vector2i(-1, 0): 2,
	Vector2i(-1, 1): 3,
	Vector2i(0, 1): 4,
	Vector2i(1, 1): 5,
	Vector2i(1, 0): 6,
	Vector2i(1, -1): 7,
}

	
func set_directionality(direction: Vector2i) -> void:
	if not direction_mapping.has(direction): return
	
	match direction_dimension:
		DirectionDimension.X: frame_coords.x = direction_mapping[direction]
		DirectionDimension.Y: frame_coords.y = direction_mapping[direction]
