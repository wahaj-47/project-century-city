@tool
class_name ShapeQuery
extends TargetQuery

func find_target(context: Node3D) -> Dictionary:
    var space_state := context.get_world_3d().direct_space_state
    return {}