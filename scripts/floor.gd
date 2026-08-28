class_name floor extends GridMap

func convertCellCoords(globalPos) -> Vector2i:
	var localX = (-4+globalPos.x)/8 
	var localY = (-4+globalPos.z)/8
	return Vector2i(localX, localY)
	
func getPos(groupMember) -> Vector2i:
	var entity = get_tree().get_first_node_in_group(groupMember)
	return convertCellCoords(entity.global_position)

func _ready() -> void:
	pass
	
