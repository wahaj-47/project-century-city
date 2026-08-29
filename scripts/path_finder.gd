class_name pathFinder
extends Node

var astar_grid = AStarGrid2D.new()
var START_X = -56
var START_Y = -160
var SIZE_X = 112
var SIZE_Y = 176

func get_directions(path) -> Array:
	var directions = []
	for i in range(path.size() - 1):
		var direction_x = path[i + 1].x - path[i].x
		var direction_y = path[i + 1].y - path[i].y
		directions.append(Vector3i(direction_x, 0, direction_y))
	return directions

func create_grid() -> void:
	astar_grid.region = Rect2i(START_X, START_Y, SIZE_X, SIZE_Y)
	astar_grid.cell_size = Vector2i(8, 8)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var blocked_cells = load("res://blockedCells.tres")
	for cell in blocked_cells.walls:
		astar_grid.set_point_solid(cell, true)
	for cell in blocked_cells.corners:
		astar_grid.set_point_solid(cell, true)

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	create_grid()
