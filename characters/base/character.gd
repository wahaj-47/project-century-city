class_name Character
extends CharacterBody3D

@onready var state_machine: LimboHSM = $StateMachine
@onready var waiting_for_turn_state: LimboState = $StateMachine/WaitingForTurn
@onready var taking_turn_state: LimboHSM = $StateMachine/TakingTurn

@onready var character_movement_component: CharacterMovementComponent = $CharacterMovementComponent
@onready var interaction_ability_component: InteractionAbilityComponent = $InteractionAbilityComponent

func _ready() -> void:
	# Initial state
	state_machine.initial_state = taking_turn_state

	# Transitions between states
	state_machine.add_transition(waiting_for_turn_state, taking_turn_state, &'turn_started')
	state_machine.add_transition(taking_turn_state, waiting_for_turn_state, &'turn_ended')

	state_machine.initialize(self)
	state_machine.set_active(true)

func get_character_movement_component() -> CharacterMovementComponent:
	return character_movement_component

func get_interaction_ability_component() -> InteractionAbilityComponent:
	return interaction_ability_component
