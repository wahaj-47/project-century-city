@tool
class_name AStarGridMap
extends GridMap

@export_tool_button("Generate AStar Grid") var generate_button = generate_astar_grid

@export var region: Rect2i = Rect2i(0, 0, 0, 0)
@export var diagonal_mode: AStarGrid2D.DiagonalMode = AStarGrid2D.DIAGONAL_MODE_NEVER
@export var solids: Array[String] = []

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var solid_cells: Array[Vector2i] = []

var astar_grid: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	print("Building AStar Grid...")
	build_astar_grid()

func generate_astar_grid() -> void:
	print("Generating AStar Grid...")

	var used_cells := get_used_cells()

	if used_cells.is_empty():
		push_warning("GridMap contains no cells.")
		return

	var min_x := used_cells[0].x
	var max_x := used_cells[0].x
	var min_z := used_cells[0].z
	var max_z := used_cells[0].z

	for cell in used_cells:
		min_x = mini(min_x, cell.x)
		max_x = maxi(max_x, cell.x)
		min_z = mini(min_z, cell.z)
		max_z = maxi(max_z, cell.z)

	region = Rect2i(
		min_x,
		min_z,
		max_x - min_x + 1,
		max_z - min_z + 1
	)

	solid_cells.clear()

	for solid_name in solids:
		var item := mesh_library.find_item_by_name(solid_name)

		if item == -1:
			push_warning(
				"Could not find MeshLibrary item: " + solid_name
			)
			continue

		for cell in get_used_cells_by_item(item):
			solid_cells.append(
				Vector2i(cell.x, cell.z)
			)

	notify_property_list_changed()

	print("Generated AStar Grid.")
	print("Region: ", region)
	print("Solid cells: ", solid_cells.size())

func build_astar_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = region
	astar_grid.cell_size = Vector2(cell_size.x, cell_size.z)
	astar_grid.diagonal_mode = diagonal_mode
	astar_grid.update()

	for cell in solid_cells:
		if astar_grid.region.has_point(cell):
			astar_grid.set_point_solid(cell, true)

func set_cell_solid(cell: Vector2i, solid: bool) -> void:
	if astar_grid == null:
		return

	if astar_grid.region.has_point(cell):
		astar_grid.set_point_solid(cell, solid)


func is_cell_solid(cell: Vector2i) -> bool:
	if astar_grid == null:
		return true

	if not astar_grid.region.has_point(cell):
		return true

	return astar_grid.is_point_solid(cell)


func get_id_path(from: Vector2i, to: Vector2i, allow_partial_path: bool = false) -> Array[Vector2i]:
	if astar_grid == null:
		return []

	if not astar_grid.region.has_point(from):
		return []

	if not astar_grid.region.has_point(to):
		return []

	if astar_grid.is_point_solid(to):
		return []

	return astar_grid.get_id_path(from, to, allow_partial_path)

func to_grid_coords(in_position: Vector3) -> Vector2i:
	var local_position = to_local(in_position)
	var cell_coords = local_to_map(local_position)
	return Vector2i(cell_coords.x, cell_coords.z)
