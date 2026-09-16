@tool
class_name Enemy
extends Character

@onready var taking_turn_state: BTState = $StateMachine/TakingTurn

@onready var ai_perception_component: AIPerceptionComponent = $AIPerceptionComponent
var player_detected: bool = false
var num_enemies_detected: int = 0

func _ready() -> void:
	state_machine.add_transition(waiting_for_turn_state, taking_turn_state, &'turn_started')
	state_machine.add_transition(taking_turn_state, waiting_for_turn_state, &'turn_ended')

	super._ready()

func get_ai_perception_component() -> AIPerceptionComponent:
	return ai_perception_component

func on_interaction(instigator: Node3D) -> void:
	pass
