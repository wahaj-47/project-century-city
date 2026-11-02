@tool
extends InteractionHandlerNavigation

@export var mesh: Node3D
@export var obstruction_check: RayCast3D

@export var animation_duration := 0.2


func _ready() -> void:
	assert(mesh != null, "InteractionHandler must have a Mesh.")
	assert(obstruction_check != null, "InteractionHandler must have an ObstructionCheck.")


func can_interact() -> bool:
	return super.can_interact() or obstruction_check.is_colliding()


func end_interaction() -> void:
	super.end_interaction()
	obstruction_check.enabled = not obstruction_check.enabled


func open(instigator: Node3D) -> void:
	var to_instigator: Vector3 = instigator.global_position - global_position
	var door_forward: Vector3 = - global_transform.basis.z
	
	var dot: float = to_instigator.dot(door_forward)
	var target_angle: float = 0 if state == Constants.NavigationState.OPEN else 90 if dot > 0 else -90
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", deg_to_rad(target_angle), animation_duration)
	tween.finished.connect(end_interaction)
	

func close() -> void:
	super.close()
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", 0.0, animation_duration)
	tween.finished.connect(end_interaction)
	
