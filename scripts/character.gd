class_name Character
extends CharacterBody3D

@export var tile_size := 8.0
@export var move_duration := 0.16
@export var interaction_distance := 8.0

@onready var raycast_collision: RayCast3D = $RayCast3D_Collision
@onready var raycast_interaction: RayCast3D = $RayCast3D_Interaction
@onready var grid_origin: Vector3 = global_position

var grid_position := Vector3i.ZERO
var is_moving := false
var movement_tween: Tween
var current_direction := Vector3i.ZERO


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	move_and_slide()


func move_on_grid(direction: Vector3i) -> void:
	current_direction = direction

	if is_moving:
		print("is moving")
		return

	if is_blocked(direction):
		print("is blocked")
		return

	var target_grid_position := grid_position + direction
	var target_position := grid_origin + Vector3(target_grid_position) * tile_size

	grid_position = target_grid_position
	is_moving = true
	print("is moving set to true")

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
	raycast_collision.target_position = Vector3(direction) * tile_size
	raycast_collision.force_raycast_update()

	return raycast_collision.is_colliding()


func _on_movement_finished() -> void:
	print("moving is false")
	is_moving = false


func try_interact() -> void:
	raycast_interaction.target_position = Vector3(current_direction) * interaction_distance
	raycast_interaction.force_raycast_update()

	if raycast_interaction.is_colliding():
		var collider := raycast_interaction.get_collider()
		var item = collider.owner
		if item is Interactable:
			item.on_interact(self)
