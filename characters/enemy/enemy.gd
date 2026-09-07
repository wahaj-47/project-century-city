class_name Enemy
extends Character

var numEnemiesDetected: int = 0
var playerDetected: bool = false
var killPlayer: bool = false

# Enemy character uses the base character state machine.
# This is because the enemy does not have any sub states.
func _ready() -> void:
	super._ready()
