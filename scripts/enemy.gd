extends Character

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.player_moved.connect(moveEnemy)

func moveEnemy():
	var direction := get_ai_direction()
	if direction != Vector3i.ZERO:
		move_on_grid(direction)

func get_ai_direction() -> Vector3i:
	# Your AI logic goes here
	var playerPos = Floor.getPos("Player")
	var myPos = Floor.convertCellCoords(global_position)
	var path = PathFinder.astar_grid.get_id_path(myPos, playerPos, true)
	var directions = PathFinder.getDirections(path)
	if directions.is_empty():
		return Vector3i.ZERO
	else:
		return directions[0]
