extends LimboState

@export var character_movement_component: CharacterMovementComponent
@export var interaction_ability_component: InteractionAbilityComponent

var _map: AStarGridMap
var _crosshair: Decal

func _setup() -> void:
	assert(interaction_ability_component != null)
	assert(character_movement_component != null)

	_crosshair = Constants.TILE_HIGHLIGHT.instantiate() as Decal
	add_child(_crosshair)
	_crosshair.global_position = agent.global_position

	add_event_handler(&'movement_requested', _on_movement_requested)

func _enter() -> void:
	interaction_ability_component.enabled = true
	_map = blackboard.get_var("map")
	_crosshair.global_position = agent.global_position
	_crosshair.show()

func _exit() -> void:
	interaction_ability_component.enabled = false
	_crosshair.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var viewport = get_viewport() as GameViewport
		var target_position := viewport.get_mouse_position_in_world_space(agent)
		character_movement_component.look_at(target_position)
	
		if not _map.is_point_solid(target_position):
			var target_cell = _map.to_grid_coords(target_position)
			_crosshair.global_position = _map.to_world_coords(target_cell)
		

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
