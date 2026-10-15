extends Node

var turn: Constants.ActorType = Constants.ActorType.PLAYER

var active_enemy_count: int = 0

## Emitted when a turn ends
## [br]
## [code]actor: ActorType[/code] - The actor whose turn is now active
signal turn_started(actor_type)

## Starts a new turn
## [br]
## [code]actor: ActorType[/code] - The actor that started the turn
## [br]
## This is used to track how many enemies are active. It does not affect the turn itself.
func start_turn(actor: Constants.ActorType):
	match actor:
		Constants.ActorType.PLAYER:
			pass
		Constants.ActorType.ENEMY:
			active_enemy_count += 1

## Ends the current turn
## [br]
## [code]actor: ActorType[/code] - The actor that ended the turn
func end_turn(actor: Constants.ActorType):
	var enemy_count = get_tree().get_node_count_in_group("Enemy")

	match actor:
		Constants.ActorType.PLAYER:
			turn = Constants.ActorType.ENEMY if enemy_count > 0 else Constants.ActorType.PLAYER
			# Allows current state to finish processing
			await get_tree().physics_frame
			turn_started.emit(turn)
		Constants.ActorType.ENEMY:
			active_enemy_count -= 1
			if active_enemy_count == 0:
				turn = Constants.ActorType.PLAYER
				turn_started.emit(turn)
