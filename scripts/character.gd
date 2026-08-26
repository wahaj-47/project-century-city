class_name Character
extends CharacterBody3D

@export var tile_size := 8.0
@export var move_duration := 0.16

@onready var ray_cast: RayCast3D = $RayCast3D
@onready var grid_origin: Vector3 = global_position

var grid_position := Vector3i.ZERO
var is_moving := false
var movement_tween: Tween


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	move_and_slide()


func move_on_grid(direction: Vector3i) -> void:
	if is_moving:
		return

	if is_blocked(direction):
		return

	var target_grid_position := grid_position + direction
	var target_position := grid_origin + Vector3(target_grid_position) * tile_size

	grid_position = target_grid_position
	is_moving = true

	movement_tween = create_tween()

	movement_tween.tween_property(
		self,
		"global_position:x",
		target_position.x,
		move_duration
	)

	movement_tween.parallel().tween_property(
		self,
		"global_position:z",
		target_position.z,
		move_duration
	)

	movement_tween.set_trans(Tween.TRANS_QUAD)
	movement_tween.set_ease(Tween.EASE_OUT)

	movement_tween.finished.connect(_on_movement_finished)


func is_blocked(direction: Vector3i) -> bool:
	ray_cast.target_position = Vector3(direction) * tile_size
	ray_cast.force_raycast_update()

	return ray_cast.is_colliding()


func _on_movement_finished() -> void:
	is_moving = false
