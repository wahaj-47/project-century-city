class_name Enemy
extends Character
	
func _ready() -> void:
	var player: Character = get_tree().get_first_node_in_group("Player")
	player.moving.connect(move_enemy)

func move_enemy(_is_moving: bool) -> void:
	var direction := get_ai_direction()
	if direction != Vector3i.ZERO:
		move_on_grid(direction)

func get_ai_direction() -> Vector3i:
	# Your AI logic goes here
	# var player_position = Blackboard.get_player_position()
	# var path = PathFinder.astar_grid.get_id_path(grid_cell, player_position)
	# var directions = PathFinder.getDirections(path)
	var directions = []
	if directions.is_empty():
		return Vector3i.ZERO
	else:
		return directions[0]
