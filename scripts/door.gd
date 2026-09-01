extends Interactable

@onready var mesh: Node3D = $Mesh
@onready var detection_zone: Area3D = $DetectionZone
@onready var obstruction_check: RayCast3D = $ObstructionCheck

@export var animation_duration := 0.2

var open = false
var moving = false
var map

# Doors are closed by default therefore considered solid in map
func _ready() -> void:
	map = get_tree().get_first_node_in_group("Map")
	map.set_cell_solid(map.to_grid_coords(global_position), true)

func on_interact(instigator: Node3D) -> void:
	super.on_interact(instigator)

	if obstruction_check.is_colliding():
		return

	if moving:
		return

	moving = true

	if open:
		_close_door()
	else:
		_open_door(instigator)
	

func _open_door(player: Node3D) -> void:
	var to_player: Vector3 = player.global_position - global_position
	var door_forward: Vector3 = - global_transform.basis.z
	
	var dot: float = to_player.dot(door_forward)
	var target_angle: float = 0 if open else 90 if dot > 0 else -90
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", deg_to_rad(target_angle), animation_duration)
	
	tween.finished.connect(func():
		open = not open
		moving = false
		obstruction_check.enabled = true
	)
	map.set_cell_solid(map.to_grid_coords(global_position), false)
	

func _close_door() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "mesh:rotation:y", 0.0, animation_duration)
	
	tween.finished.connect(func():
		open = false
		moving = false
		obstruction_check.enabled = false
	)
	map.set_cell_solid(map.to_grid_coords(global_position), true)
