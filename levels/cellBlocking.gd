class_name cellBlocking
extends GridMap

var astar_grid: AStarGrid2D

func _ready():
	var wall_cells = get_used_cells_by_item(mesh_library.find_item_by_name("Wall"))
	var corner_cells = get_used_cells_by_item(mesh_library.find_item_by_name("Corner"))
	
	var wall_arr: Array[Vector2i] = []
	for cell in wall_cells:
		wall_arr.append(Vector2i(cell.x, cell.z))
	var corner_arr: Array[Vector2i] = []
	for cell in corner_cells:
		corner_arr.append(Vector2i(cell.x, cell.z))
		
	var blocked_cells = blockedCells.new()
	blocked_cells.walls = wall_arr
	blocked_cells.corners = corner_arr
	
	ResourceSaver.save(blocked_cells, "res://blockedCells.tres")
		
	
