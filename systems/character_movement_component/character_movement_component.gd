# A movement component that makes a CharacterBody3D move on the grid.
@tool
class_name CharacterMovementComponent
extends Node

@export var enabled = true
@export var move_speed := 50
@export var rotate_speed := 20
@export var enable_gravity := true
@export var rotate_to_face_movement := true

signal movement_started
signal movement_ended

var is_moving := false

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# Make sure the owner is a CharacterBody3D.
	assert(owner is CharacterBody3D, "CharacterMovementComponent must be attached to a CharacterBody3D.")

		
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if not enabled:
		return

	if not owner.is_on_floor() and enable_gravity:
		owner.velocity += owner.get_gravity() * _delta
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


func is_blocked(target_position: Vector3) -> bool:
	var space_state: PhysicsDirectSpaceState3D = owner.get_world_3d().direct_space_state

	var from: Vector3 = owner.global_position
	var to: Vector3 = target_position

	var query := PhysicsRayQueryParameters3D.create(from, to)

	var result := space_state.intersect_ray(query)

	return not result.is_empty()


func look_at(target_position: Vector3) -> void:
	# I don't understand this part. 
	var direction: Vector3 = target_position - owner.global_position
	var target_rotation: float = atan2(-direction.x, -direction.z)
	var current_rotation: float = owner.rotation.y

	var _delta_rotation := wrapf(
		target_rotation - current_rotation,
		- PI,
		PI
	)
	var duration : float = abs(_delta_rotation) / rotate_speed

	var rotation_tween := create_tween()
	rotation_tween.tween_property(
		owner,
		"rotation:y",
		current_rotation + _delta_rotation,
		duration
	)


func move(target_position: Vector3, check_collision := true) -> bool:
	if is_moving:
		return false

	if rotate_to_face_movement:
		look_at(target_position)
	
	if check_collision and is_blocked(target_position):
		return false
	
	is_moving = true
	movement_started.emit()


	var distance : Vector3 = target_position - owner.global_position
	var duration : float = distance.length() / move_speed

	var movement_tween = create_tween()
	movement_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	movement_tween.finished.connect(_on_movement_finished)
	movement_tween.tween_property(
		owner,
		"global_position:x",
		target_position.x,
		duration
	)
	movement_tween.parallel().tween_property(
		owner,
		"global_position:z",
		target_position.z,
		duration
	)

	return true
	

func _on_movement_finished() -> void:
	is_moving = false
	movement_ended.emit()
