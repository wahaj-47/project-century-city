@tool
class_name CellBlocking extends EditorScript

func _run() -> void:
	var current_scene = get_scene()
	var gridmap: GridMap = current_scene.get_node_or_null("floor")
	
	var wall_cells = gridmap.get_used_cells_by_item(gridmap.mesh_library.find_item_by_name("Wall"))
	var corner_cells = gridmap.get_used_cells_by_item(gridmap.mesh_library.find_item_by_name("Corner"))
	
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
