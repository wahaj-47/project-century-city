class_name Enemy
extends Character

@onready var ai_perception_component: AIPerceptionComponent = $AIPerceptionComponent
var player_detected: bool = false
var num_enemies_detected: int = 0

# Enemy character uses the base character state machine.
# This is because the enemy does not have any sub states.
func _ready() -> void:
	super._ready()

func get_ai_perception_component() -> AIPerceptionComponent:
	return ai_perception_component