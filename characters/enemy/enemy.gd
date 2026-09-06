class_name Enemy
extends Character

# Enemy character uses the base character state machine.
# This is because the enemy does not have any sub states.
func _ready() -> void:
    super._ready()