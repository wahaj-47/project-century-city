extends LimboState

@export var character_movement_component: CharacterMovementComponent
@export var crosshair: Crosshair

var _map: AStarGridMap


func _setup() -> void:
	assert(character_movement_component != null, "Character movement component not found")


func _enter() -> void:
	_map = blackboard.get_var("map")
	crosshair.show()


func _exit() -> void:
	crosshair.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		character_movement_component.look_at(crosshair.global_position)

	if event.is_action_pressed("interact"):
		if crosshair.hit_result.is_empty(): return
		if crosshair.hit_result.collider is not InteractionHandler: return
		
		blackboard.set_var("interaction_target", crosshair.hit_result.collider)
		dispatch(&'interaction_started')
		
	if event.is_action_pressed("move"):
		blackboard.set_var("path", crosshair.path)
		dispatch(&'movement_started')
		
