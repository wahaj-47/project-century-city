extends LimboState

@export var interaction_ability_component: InteractionAbilityComponent

func _setup() -> void:
	assert(interaction_ability_component != null)
	interaction_ability_component.interaction_ended.connect(_on_interaction_ended)

func _enter() -> void:
	interaction_ability_component.try_interact()

func _on_interaction_ended() -> void:
	dispatch(&'interaction_ended')
