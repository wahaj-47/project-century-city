extends BTState

@export var waiting_for: GameState.ActorType

func _setup() -> void:
	GameState.turn_ended.connect(_on_turn_ended)

func _enter() -> void:
	#print(agent.name, ": WaitingForTurn")
	pass

func _exit() -> void:
	var character = agent as Character
	GameState.start_turn(character.actor_type)
	
func _on_turn_ended(actor_type: GameState.ActorType) -> void:
	if actor_type == waiting_for:
		dispatch(&'turn_started')
