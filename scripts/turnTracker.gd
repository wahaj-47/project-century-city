extends Node

enum ActorType {PLAYER, ENEMIES}
@export var turn: ActorType = ActorType.PLAYER

func flipTracker():
	#turn = ActorType.ENEMIES if turn == ActorType.PLAYER else ActorType.PLAYER
	turn = 1 - turn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
