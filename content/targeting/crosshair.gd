class_name Crosshair
extends Decal

@export var target_query: TargetQuery
var hit_result: Dictionary
var map: AStarGridMap

func _physics_process(_delta: float) -> void:
	hit_result = target_query.find_target(self)
	
	if map == null: return

	if not hit_result.is_empty():
		var snapped_position = map.to_world_coords(map.to_grid_coords(hit_result.position))
		global_position = snapped_position
