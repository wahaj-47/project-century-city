extends LimboState

var character: Character

func _setup() -> void:
	character = agent as Character

func _exit() -> void:
	GameState.end_turn(character.actor_type)

func end_turn() -> void:
	dispatch(&"turn_ended")
