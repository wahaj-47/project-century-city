class_name Player
extends Character

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_moving:
		return
		
func input_handler(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		move_on_grid(Vector3i.FORWARD)
		
	if event.is_action_pressed("move_backward"):
		move_on_grid(Vector3i.BACK)

	if event.is_action_pressed("move_left"):
		move_on_grid(Vector3i.LEFT)

	if event.is_action_pressed("move_right"):
		move_on_grid(Vector3i.RIGHT)

	if event.is_action_pressed("interact"):
		try_interact()
		
func _input(event: InputEvent) -> void:
	input_handler(event)
