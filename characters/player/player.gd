class_name Player
extends Character

@onready var idle_state: LimboState = $StateMachine/TakingTurn/Idle
@onready var moving_state: LimboState = $StateMachine/TakingTurn/Moving
@onready var interacting_state: LimboState = $StateMachine/TakingTurn/Interacting

func _ready() -> void:
    super._ready()

    # Initial state
    taking_turn_state.initial_state = idle_state

    # Transitions between states
    taking_turn_state.add_transition(idle_state, moving_state, &'movement_started') # Idle -> Moving
    taking_turn_state.add_transition(idle_state, interacting_state, &'interaction_started') # Idle -> Interacting
    taking_turn_state.add_transition(interacting_state, idle_state, &'interaction_ended') # Interacting -> Idle