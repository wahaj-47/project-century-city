# A movement component that makes a CharacterBody3D move on the grid.

@tool
class_name CharacterMovementComponent
extends Node3D

@export var tile_size := 8.0
@export var move_duration := 0.16
@export var rotate_duration := 0.08
@export var enable_gravity := true
@export var rotate_to_face_movement := true

signal movement_started
signal movement_ended

var is_moving := false

func _ready() -> void:
	# Make sure the owner is a CharacterBody3D.
	assert(owner is CharacterBody3D, "CharacterMovementComponent must be attached to a CharacterBody3D.")

		
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if not owner.is_on_floor() and enable_gravity:
		owner.velocity += owner.get_gravity() * delta
	else:
		owner.velocity.y = 0.0

	owner.move_and_slide()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if Engine.is_editor_hint() and owner == null:
		return warnings

	if owner is not CharacterBody3D:
		warnings.append("The CharacterMovementComponent must be a child of the CharacterBody3D.")

	return warnings


func is_blocked(direction: Vector3i) -> bool:
	var space_state: PhysicsDirectSpaceState3D = owner.get_world_3d().direct_space_state

	var from: Vector3 = owner.global_position
	var to: Vector3 = owner.global_position + (direction * tile_size)

	var query := PhysicsRayQueryParameters3D.create(from, to)

	var result := space_state.intersect_ray(query)

	return not result.is_empty()


func move(direction: Vector3i) -> bool:
	if is_moving:
		return false

	# I don't understand this part. 
	var target_rotation: float = atan2(-direction.x, -direction.z)
	var current_rotation: float = owner.rotation.y

	var delta_rotation := wrapf(
		target_rotation - current_rotation,
		- PI,
		PI
	)

	var rotation_tween := create_tween()
	rotation_tween.tween_property(
		owner,
		"rotation:y",
		current_rotation + delta_rotation,
		rotate_duration
	)

	if is_blocked(direction):
		is_moving = false
		return false
	
	is_moving = true
	movement_started.emit()

	var target_position: Vector3 = owner.global_position + (direction * tile_size)
	var movement_tween = create_tween()
	movement_tween.set_trans(Tween.TRANS_QUAD)
	movement_tween.set_ease(Tween.EASE_OUT)
	movement_tween.finished.connect(_on_movement_finished)
	movement_tween.tween_property(
		owner,
		"global_position:x",
		target_position.x,
		move_duration
	)
	movement_tween.parallel().tween_property(
		owner,
		"global_position:z",
		target_position.z,
		move_duration
	)

	return true
	

func _on_movement_finished() -> void:
	is_moving = false
	movement_ended.emit()