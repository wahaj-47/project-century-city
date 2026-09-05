extends LimboState

var character_movement_component: CharacterMovementComponent

func _setup() -> void:
	var character: Character = get_agent()
	character_movement_component = character.get_character_movement_component()
	character_movement_component.movement_ended.connect(_on_movement_ended)

func _enter() -> void:
	print("Entered Moving state")

func _on_movement_ended() -> void:
	dispatch(&'turn_ended')
