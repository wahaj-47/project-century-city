class_name Player
extends Character

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_moving:
		return

func execute_action(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		move_on_grid(Vector3i.FORWARD)
		TurnTracker.flipTracker()
	if event.is_action_pressed("move_backward"):
		move_on_grid(Vector3i.BACK)
		TurnTracker.flipTracker()
	if event.is_action_pressed("move_left"):
		move_on_grid(Vector3i.LEFT)
		TurnTracker.flipTracker()
	if event.is_action_pressed("move_right"):
		move_on_grid(Vector3i.RIGHT)
		TurnTracker.flipTracker()
	
		
func input_handler(event: InputEvent) -> void:
	if TurnTracker.turn == TurnTracker.ActorType.PLAYER:
		if event.is_action_pressed("interact"):
			try_interact()
			# Player interacting with an object counts as a turn
			#TurnTracker.flipTracker()
		else:
			execute_action(event)
		

	
		
func _input(event: InputEvent) -> void:
	input_handler(event)
