@tool
class_name Character
extends CharacterBody3D

@onready var state_machine: LimboHSM = $StateMachine
@onready var waiting_for_turn_state: LimboState = $StateMachine/WaitingForTurn
@onready var dead_state: LimboState = $StateMachine/Dead

@onready var character_movement_component: CharacterMovementComponent = $CharacterMovementComponent
@onready var interaction_ability_component: InteractionAbilityComponent = $InteractionAbilityComponent
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var sprite_zd: SpriteZD = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export var actor_type: Constants.ActorType
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

var dead: bool = false

var camera: Camera3D


func initialize(config: CharacterConfig) -> void:
	state_machine.blackboard.set_var("map", config.map)
	state_machine.initialize(self)
	state_machine.set_active(true)


func _ready() -> void:
	# Initial state
	state_machine.initial_state = initial_state
	state_machine.add_transition(state_machine.ANYSTATE, dead_state, &"destroyed")

	_update_animation_player()
	camera = get_viewport().get_camera_3d()


# # Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return

	var forward := get_character_forward()
	# Project forward onto camera's right and forward axes to get view-space direction
	var camera_basis := camera.global_transform.basis
	var v := camera_basis.transposed() * forward
	var direction := Vector2(v.x, v.z)

	sprite_zd.set_directionality(direction)


func destroy() -> void:
	character_movement_component.enabled = false
	interaction_ability_component.enabled = false
	collision.disabled = true
	pending_kill = true


func get_character_forward() -> Vector3:
	return -global_transform.basis.z


func get_character_right() -> Vector3:
	return global_transform.basis.x


func get_character_movement_component() -> CharacterMovementComponent:
	return character_movement_component


func get_interaction_ability_component() -> InteractionAbilityComponent:
	return interaction_ability_component


func die(animation_name: StringName) ->  void:
	animation_tree["parameters/Locomotion/death/Transition/transition_request"] = animation_name
	dead = true


func play_anim_montage(animation_name: StringName) -> void:
	animation_tree["parameters/AnimMontage/Transition/transition_request"] = animation_name
	animation_tree["parameters/Slot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func is_montage_playing() -> bool:
	return animation_tree.active && animation_tree["parameters/Slot/active"]


func apply_movement(target_position: Vector3, check_collision := true) -> bool:
	return character_movement_component.move(target_position, check_collision)


func apply_rotation(target_position: Vector3) -> void:
	character_movement_component.look_at(target_position)


func _update_animation_player() -> void:
	if animation_player == null:
		return

	print("Updating animation player")
		
	if animation_player.has_animation_library(""):
		animation_player.remove_animation_library("")

	animation_player.add_animation_library("", animation_library)
