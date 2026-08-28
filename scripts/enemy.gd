extends Character

signal enemy_moving(bool)
	
func _on_movement_finished() -> void:
	super._on_movement_finished()
	enemy_moving.emit(false)
	
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.player_moved.connect(moveEnemy)

func moveEnemy():
	var direction := get_ai_direction()
	if direction != Vector3i.ZERO:
		enemy_moving.emit(true)
		move_on_grid(direction)

func get_ai_direction() -> Vector3i:
	# Your AI logic goes here
	var playerPos = Blackboard.findPlayer()
	var myPos = Blackboard.convertCellCoords(global_position)
	var path = PathFinder.astar_grid.get_id_path(myPos, playerPos)
	var directions = PathFinder.getDirections(path)
	if directions.is_empty():
		return Vector3i.ZERO
	else:
		return directions[0]
