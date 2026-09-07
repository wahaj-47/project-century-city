class_name Enemy
extends Character

var num_enemies_detected: int = 0
var player_detected: bool = false
var kill_player: bool = false

# Enemy character uses the base character state machine.
# This is because the enemy does not have any sub states.
func _ready() -> void:
	super._ready()
