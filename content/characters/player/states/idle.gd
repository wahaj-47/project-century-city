extends LimboState

@export var character_movement_component: CharacterMovementComponent
@export var interaction_ability_component: InteractionAbilityComponent
@export var crosshair: Crosshair

var _map: AStarGridMap


func _setup() -> void:
	assert(interaction_ability_component != null, "Interaction ability component not found")
	assert(character_movement_component != null, "Character movement component not found")


func _enter() -> void:
	_map = blackboard.get_var("map")
	crosshair.show()


func _exit() -> void:
	crosshair.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		character_movement_component.look_at(crosshair.global_position)
		
	if event.is_action_pressed("select"):
		handle_selection()

func handle_selection() -> void:
	if not crosshair.hit_result.is_empty() and crosshair.hit_result.collider is InteractionHandler:
		blackboard.set_var("interaction_target", crosshair.hit_result.collider)
		dispatch(&'interaction_started')
	else:
		blackboard.set_var("path", crosshair.path)
		dispatch(&'movement_started')
