extends LimboState

@export var interaction_ability_component: InteractionAbilityComponent

func _setup() -> void:
	assert(interaction_ability_component != null)
	interaction_ability_component.interaction_ended.connect(_on_interaction_ended)

func _enter() -> void:
	var interaction_target = blackboard.get_var("interaction_target") as InteractionHandler
	interaction_ability_component.try_interact(interaction_target)

func _on_interaction_ended() -> void:
	dispatch(&'interaction_ended')
