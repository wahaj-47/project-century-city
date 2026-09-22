@tool
extends InteractionHandler

@export var character_movement_component: CharacterMovementComponent

func _ready() -> void:
	assert(character_movement_component != null, "InteractionHandler must have a CharacterMovementComponent.")

func interact(instigator: Node3D) -> void:
	super.interact(instigator)

	interaction_started.emit()
	var direction := -instigator.global_transform.basis.z.normalized()
	var movement_successful := character_movement_component.move(direction)

	if not movement_successful:
		interaction_ended.emit()
		return
		
	character_movement_component.movement_ended.connect(func(): interaction_ended.emit(), CONNECT_ONE_SHOT)
