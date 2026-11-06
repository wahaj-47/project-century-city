extends LimboState

@export var character_movement_component: CharacterMovementComponent
var path: PackedVector3Array
var step: int = 1;


func _setup() -> void:
	assert(character_movement_component != null)
	character_movement_component.movement_ended.connect(_on_movement_ended)


func _enter() -> void:
	step = 1
	path = blackboard.get_var("path")

	character_movement_component.move(path[step])


func _on_movement_ended() -> void:
	step += 1
	
	if step < path.size():
		character_movement_component.move(path[step])
	else:	
		dispatch(&'turn_ended')
