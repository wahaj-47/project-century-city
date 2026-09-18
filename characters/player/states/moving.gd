extends LimboState

@export var character_movement_component: CharacterMovementComponent

func _setup() -> void:
	assert(character_movement_component != null)
	character_movement_component.movement_ended.connect(_on_movement_ended)

func _on_movement_ended() -> void:
	dispatch(&'turn_ended')
