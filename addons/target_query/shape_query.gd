@tool
class_name ShapeQuery
extends TargetQuery

func find_target(origin: Node3D) -> Dictionary:
    var space_state := origin.get_world_3d().direct_space_state
    return {}