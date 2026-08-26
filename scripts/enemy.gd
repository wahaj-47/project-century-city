extends Character

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_moving:
		return

	var direction := get_ai_direction()

	if direction != Vector3i.ZERO:
		move_on_grid(direction)


func get_ai_direction() -> Vector3i:
	# Your AI logic goes here
	return Vector3i.LEFT
