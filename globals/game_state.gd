extends Node

enum ActorType {NONE, PLAYER, ENEMY}

var player: Character
var map: AStarGridMap
var turn: ActorType = ActorType.PLAYER
var enemy_count: int = 0
var active_enemy_count: int = 0

signal turn_ended(actor_type)

func _ready() -> void:
	enemy_count = get_tree().get_node_count_in_group("Enemy")
	print("Enemy count: %d" % enemy_count)

## Starts a new turn
## [br]
## [code]actor: ActorType[/code] - The actor that started the turn
## [br]
## This is used to track how many enemies are active. It does not affect the turn itself.
func start_turn(actor: ActorType):
	match actor:
		ActorType.PLAYER:
			pass
		ActorType.ENEMY:
			active_enemy_count += 1

## Ends the current turn
## [br]
## [code]actor: ActorType[/code] - The actor that ended the turn
func end_turn(actor: ActorType):
	match actor:
		ActorType.PLAYER:
			turn = ActorType.ENEMY if enemy_count > 0 else ActorType.PLAYER

			# Allows current state to finish processing
			await get_tree().physics_frame

			turn_ended.emit(turn)
		ActorType.ENEMY:
			active_enemy_count -= 1
			if active_enemy_count == 0:
				turn = ActorType.PLAYER
				turn_ended.emit(turn)
