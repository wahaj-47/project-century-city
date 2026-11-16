extends Node

var turn: Constants.ActorType = Constants.ActorType.PLAYER
var active_enemy_count: int = 0

## Emitted when a turn starts
## [br]
## [code]actor: ActorType[/code] - The actor whose turn started.
signal turn_started(actor_type: Constants.ActorType, turn_budget: int)


## Activates an actor for their turn
## [br]
## [code]actor: ActorType[/code] - The actor to activate
## [br]
## This is used to track how many actors are active
func activate(actor: Constants.ActorType):
	match actor:
		Constants.ActorType.PLAYER:
			pass
		Constants.ActorType.ENEMY:
			active_enemy_count += 1


## Ends the current turn
## [br]
## [code]actor: ActorType[/code] - The actor that ended the turn
## [code]turn_budget[/code] - Turn budget that actor used
func end_turn(actor: Constants.ActorType, turn_budget: int = 1):
	var enemy_count = get_tree().get_node_count_in_group("Enemy")

	match actor:
		Constants.ActorType.PLAYER:
			turn = Constants.ActorType.ENEMY if enemy_count > 0 else Constants.ActorType.PLAYER

		Constants.ActorType.ENEMY:
			active_enemy_count -= 1
			if active_enemy_count > 0:
				return
			
			turn = Constants.ActorType.PLAYER

	turn_started.emit(turn, turn_budget)