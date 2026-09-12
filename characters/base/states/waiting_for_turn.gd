extends BTState

var character: Character

func _setup() -> void:
	character = agent as Character
	GameState.turn_ended.connect(_on_turn_ended)

func _exit() -> void:
	GameState.start_turn(character.actor_type)
	
func _on_turn_ended(next_turn: GameState.ActorType) -> void:
	if next_turn == character.actor_type:
		dispatch(&"turn_started")
