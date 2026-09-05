extends LimboState

var character_movement_component: CharacterMovementComponent

func _setup() -> void:
	var character: Character = get_agent()
	character_movement_component = character.get_character_movement_component()
	add_event_handler(&'movement_requested', _on_movement_requested)

func _enter() -> void:
	print("Entered Idle state")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		dispatch(&'movement_requested', Vector3i.FORWARD)
	elif event.is_action_pressed("move_backward"):
		dispatch(&'movement_requested', Vector3i.BACK)
	elif event.is_action_pressed("move_left"):
		dispatch(&'movement_requested', Vector3i.LEFT)
	elif event.is_action_pressed("move_right"):
		dispatch(&'movement_requested', Vector3i.RIGHT)
	elif event.is_action_pressed("interact"):
		dispatch(&'interaction_started')

func _on_movement_requested(direction: Vector3i = Vector3i.ZERO) -> bool:
	if not character_movement_component.move(direction):
		return false
	
	dispatch(&'movement_started')
	return true
