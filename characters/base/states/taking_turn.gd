extends LimboState

func _enter() -> void:
	print(agent.name, ": TakingTurn")

func _exit() -> void:
	var character = agent as Character
	GameState.end_turn(character.actor_type)
