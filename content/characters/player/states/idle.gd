extends LimboState

@export var character_movement_component: CharacterMovementComponent
@export var interaction_ability_component: InteractionAbilityComponent


func _setup() -> void:
	assert(interaction_ability_component != null)
	assert(character_movement_component != null)
	add_event_handler(&'movement_requested', _on_movement_requested)

func _enter() -> void:
	interaction_ability_component.enabled = true

func _exit() -> void:
	interaction_ability_component.enabled = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		dispatch(&'movement_requested', Vector3i.LEFT)
	elif event.is_action_pressed("move_backward"):
		dispatch(&'movement_requested', Vector3i.RIGHT)
	elif event.is_action_pressed("move_left"):
		dispatch(&'movement_requested', Vector3i.BACK)
	elif event.is_action_pressed("move_right"):
		dispatch(&'movement_requested', Vector3i.FORWARD)
	elif event.is_action_pressed("interact"):
		dispatch(&'interaction_started')

func _on_movement_requested(direction: Vector3i = Vector3i.ZERO) -> bool:
	if not character_movement_component.move(agent.global_position + direction * Constants.tile_size):
		return false
	
	dispatch(&'movement_started')
	return true
