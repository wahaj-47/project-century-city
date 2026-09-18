class_name WaitingForTurn
extends BTState

var character: Character
@export var interaction_handler: InteractionHandler

func _setup() -> void:
	character = agent as Character
	GameState.turn_ended.connect(_on_turn_ended)


func _enter() -> void:
	if interaction_handler != null:
		interaction_handler.enabled = true


func _exit() -> void:
	if interaction_handler != null:
		interaction_handler.enabled = false

	GameState.start_turn(character.actor_type)
	

func _on_turn_ended(next_turn: GameState.ActorType) -> void:
	if next_turn == character.actor_type:
		dispatch(&"turn_started")
