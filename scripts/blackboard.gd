#Helper functions
extends Node

var enemyMoving: bool = false

func convertCellCoords(globalPos) -> Vector2i:
	var localX = (-4+globalPos.x)/8 
	var localY = (-4+globalPos.z)/8
	return Vector2i(localX, localY)

func findPlayer() -> Vector2i:
	var player = get_tree().get_first_node_in_group("Player")
	return convertCellCoords(player.global_position)

func movementAllowed(enemyMovement: bool):
	enemyMoving = enemyMovement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.enemy_moving.connect(movementAllowed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
