extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var astar_grid := AStarGrid2D.new()
	astar_grid.region = Rect2i(0,0, 80, 80)
	astar_grid.cell_size = Vector2i(8, 8)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var blockedCells = preload("res://blockedCells.tres")
	for cell in blockedCells.walls:
		astar_grid.set_point_solid(cell,true)
	for cell in blockedCells.corners:
		astar_grid.set_point_solid(cell,true)
