extends LimboState

@export var character_movement_component: CharacterMovementComponent


func _setup() -> void:
	assert(character_movement_component != null)
	character_movement_component.movement_ended.connect(_on_movement_ended)


func _enter() -> void:
	var target_position = blackboard.get_var("target_position")
	if not character_movement_component.move(target_position): dispatch(&'movement_ended')


func _on_movement_ended() -> void:
	dispatch(&'turn_ended')
