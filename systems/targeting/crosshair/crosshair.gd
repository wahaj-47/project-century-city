class_name Crosshair
extends Decal

@export var target_query: CursorQuery
@export var show_trail: bool = false
@export var trail: PackedScene

var hit_result: Dictionary
var map: AStarGridMap

var _pool = []
var n_active = 0
var path: PackedVector3Array


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _unhandled_input(event: InputEvent) -> void:
	if not visible: return

	# @TODO: Handle controller input for crosshair movement.
	if event is InputEventMouseMotion:
		handle_input()

	
func handle_input() -> void:
	hit_result = target_query.find_target(self)
	if not hit_result.is_empty():
		var snapped_position = map.to_world_coords(map.to_grid_coords(hit_result.position))
		
		if snapped_position.is_equal_approx(global_position): return
		
		global_position = snapped_position
		if show_trail:
			draw_trail(owner.global_position, global_position)


func draw_trail(from: Vector3, to: Vector3) -> void:
	if map == null: return

	path = map.get_world_path(from, to)
	var n =  maxi(path.size() - 2, 0)
	
	for i in range(n):
		var world_position = path[i + 1]
		var instance = _get_or_create_instance(i)
		instance.global_position = world_position

	for i in range(n, n_active):
		_pool[i].hide()
	
	n_active = n


func _get_or_create_instance(index: int) -> Node:
	# Grab an instance from pool and return
	# Explicitly set the instance to be visible
	if index < _pool.size():
		var pooled_instance = _pool[index]
		pooled_instance.show()
		return pooled_instance

	# Create a new instance, add it to the pool, and return
	# New instance is automatically visible when created
	var instance = trail.instantiate()
	_pool.append(instance)
	add_child(instance)
	return instance


func _clear_trail() -> void:
	for instance in _pool:
		instance.hide()
	n_active = 0


func _on_visibility_changed() -> void:
	if not visible: _clear_trail()