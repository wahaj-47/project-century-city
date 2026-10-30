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
		# Match agent position on y-axis so the collision is calculated correctly for movement.
		var target_position = crosshair.global_position
		target_position.y = agent.global_position.y
		blackboard.set_var("target_position", target_position)
		blackboard.set_var("interaction_target", crosshair.hit_result.collider)

		if crosshair.hit_result.collider is InteractionHandler: dispatch(&'interaction_started')
		else: dispatch(&'movement_started')
