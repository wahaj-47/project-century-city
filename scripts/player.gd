extends Character

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_moving:
		return

	if Input.is_action_just_pressed("move_forward"):
		move_on_grid(Vector3i.FORWARD)

	elif Input.is_action_just_pressed("move_backward"):
		move_on_grid(Vector3i.BACK)

	elif Input.is_action_just_pressed("move_left"):
		move_on_grid(Vector3i.LEFT)

	elif Input.is_action_just_pressed("move_right"):
		move_on_grid(Vector3i.RIGHT)

	if Input.is_action_just_pressed("interact"):
		try_interact()
