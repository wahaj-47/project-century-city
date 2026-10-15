class_name WaitingForTurn
extends BTState

@export var interaction_ability_component: InteractionAbilityComponent
@export var interaction_handler: InteractionHandler

var character: Character

func _setup() -> void:
	character = agent as Character
	GameState.turn_started.connect(_on_turn_started)


func _enter() -> void:
	if interaction_handler != null:
		interaction_handler.enabled = true


func _exit() -> void:
	if interaction_handler != null:
		interaction_handler.enabled = false

	GameState.start_turn(character.actor_type)
	

func _on_turn_started(actor_type: Constants.ActorType) -> void:
	if actor_type == character.actor_type:
		dispatch(&"turn_started")
