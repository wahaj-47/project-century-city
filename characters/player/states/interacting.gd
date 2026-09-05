extends LimboState

var interaction_ability_component: InteractionAbilityComponent

func _setup() -> void:
	var character: Character = get_agent()
	interaction_ability_component = character.get_interaction_ability_component()
	interaction_ability_component.interaction_ended.connect(_on_interaction_ended)

func _enter() -> void:
	print("Entered Interacting state")
	interaction_ability_component.try_interact()

func _on_interaction_ended() -> void:
	dispatch(&'interaction_ended')
