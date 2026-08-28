extends Node

var enemyMoving: bool = false

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
