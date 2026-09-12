class_name Enemy
extends Character

@onready var ai_perception_component: Area3D = $AIPerceptionComponent

var player_detected: bool = false
var num_enemies_detected: int = 0

# Enemy character uses the base character state machine.
# This is because the enemy does not have any sub states.
func _ready() -> void:
	super._ready()

	ai_perception_component.connect("body_entered", _on_body_entered)
	ai_perception_component.connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body == self: return
	if body is Enemy: num_enemies_detected += 1
	if body is Player: player_detected = true

func _on_body_exited(body: Node3D) -> void:
	if body is Enemy: num_enemies_detected -= 1