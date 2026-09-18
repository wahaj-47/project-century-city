@tool
extends InteractionHandler

@export var mesh: Node3D
@export var obstruction_check: RayCast3D
@export var interaction_handler: InteractionHandler

@export var animation_duration := 0.2

var open = false
var moving = false

func interact(instigator: Node3D) -> void:
	super.interact(instigator)

	if obstruction_check.is_colliding():
		return

	if moving:
		return

	interaction_started.emit()
	moving = true

	if open:
		_close_door()
	else:
		_open_door(instigator)

func _open_door(instigator: Node3D) -> void:
	var to_instigator: Vector3 = instigator.global_position - global_position
	var door_forward: Vector3 = - global_transform.basis.z
	
	var dot: float = to_instigator.dot(door_forward)
	var target_angle: float = 0 if open else 90 if dot > 0 else -90
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", deg_to_rad(target_angle), animation_duration)
	
	tween.finished.connect(func():
		open = not open
		moving = false
		obstruction_check.enabled = true
		interaction_ended.emit()
	)
	GameState.map.set_point_solid(global_position, false)
	

func _close_door() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", 0.0, animation_duration)
	
	tween.finished.connect(func():
		open = false
		moving = false
		obstruction_check.enabled = false
		interaction_ended.emit()
	)
	GameState.map.set_point_solid(global_position, true)
