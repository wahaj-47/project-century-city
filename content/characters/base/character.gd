@tool
class_name Character
extends CharacterBody3D

@onready var state_machine: LimboHSM = $StateMachine
@onready var waiting_for_turn_state: LimboState = $StateMachine/WaitingForTurn
@onready var dead_state: LimboState = $StateMachine/Dead

@onready var character_movement_component: CharacterMovementComponent = $CharacterMovementComponent
@onready var interaction_ability_component: InteractionAbilityComponent = $InteractionAbilityComponent
@onready var sprite_zd: SpriteZD = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var actor_type: GameState.ActorType
@export var initial_state: LimboState
@export var animation_library: AnimationLibrary:
	set(value):
		animation_library = value
		_update_animation_player()
		
# Animation variables
var is_moving: bool:
	get:
		if Engine.is_editor_hint(): return false
		if character_movement_component == null: return false
		return character_movement_component.is_moving

var pending_kill: bool = false:
	set(value):
		if pending_kill == value: return
		pending_kill = value
		if pending_kill: state_machine.dispatch(&"destroyed")

var camera: Camera3D


func _ready() -> void:
	state_machine.add_transition(state_machine.ANYSTATE, dead_state, &"destroyed")
	
	# Initial state
	state_machine.initial_state = initial_state
	
	state_machine.initialize(self)
	state_machine.set_active(true)

	_update_animation_player()

	camera = get_viewport().get_camera_3d()


# # Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return

	var forward := get_character_forward()
	# Project forward onto camera's right and forward axes to get view-space direction
	var camera_basis := camera.global_transform.basis
	var v := camera_basis.transposed() * Vector3(forward)
	var direction := Vector2(v.x, -v.z).round()

	## The Z axis is inverted because positive Z is down in Godot.
	sprite_zd.set_directionality(Vector2(direction.x, direction.y))


func destroy() -> void:
	print("Destroying ", name)
	pending_kill = true


func get_character_forward() -> Vector3i:
	return -global_transform.basis.z.round()


func get_character_right() -> Vector3i:
	return global_transform.basis.x.round()


func get_character_movement_component() -> CharacterMovementComponent:
	return character_movement_component


func get_interaction_ability_component() -> InteractionAbilityComponent:
	return interaction_ability_component


func apply_movement(direction: Vector3i) -> bool:
	return character_movement_component.move(direction)


func _update_animation_player() -> void:
	if animation_player == null:
			return

	print("Updating animation player")
		
	if animation_player.has_animation_library(""):
		animation_player.remove_animation_library("")

	animation_player.add_animation_library("", animation_library)
