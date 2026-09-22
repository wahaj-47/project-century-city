@tool
class_name Character
extends CharacterBody3D

@onready var state_machine: LimboHSM = $StateMachine
@onready var waiting_for_turn_state: LimboState = $StateMachine/WaitingForTurn

@onready var character_movement_component: CharacterMovementComponent = $CharacterMovementComponent
@onready var interaction_ability_component: InteractionAbilityComponent = $InteractionAbilityComponent
@onready var animation_player: AnimationPlayer = $SpriteZD/AnimationPlayer

@export var actor_type: GameState.ActorType
@export var initial_state: LimboState
@export var animation_library: AnimationLibrary:
	set(value):
		animation_library = value
		_update_animation_player()
		
# Animation variables
var is_moving: bool:
	get:
		if character_movement_component == null:
			return false
		return character_movement_component.is_moving

func _ready() -> void:
	# Initial state
	state_machine.initial_state = initial_state
	
	state_machine.initialize(self)
	state_machine.set_active(true)

	_update_animation_player()


func _setup_state_transitions() -> void:
	pass


func get_character_forward() -> Vector3i:
	return -global_transform.basis.z.normalized()


func get_character_right() -> Vector3i:
	return global_transform.basis.x.normalized()


func get_character_movement_component() -> CharacterMovementComponent:
	return character_movement_component


func get_interaction_ability_component() -> InteractionAbilityComponent:
	return interaction_ability_component


func apply_movement(direction: Vector3i) -> bool:
	return character_movement_component.move(direction)


func _update_animation_player() -> void:
	if animation_player == null:
			return
		
	if animation_player.has_animation_library(""):
		animation_player.remove_animation_library("")

	animation_player.add_animation_library("", animation_library)
