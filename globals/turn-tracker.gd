extends Node

enum ActorType {PLAYER, ENEMIES}
@export var turn: ActorType = ActorType.PLAYER

func end_turn():
	turn = 1 - turn as ActorType
