@tool
class_name InteractionAbilityComponent
extends Node

@export var interaction_distance := 8.0

@onready var raycast_interaction: RayCast3D = $RayCast3D_Interaction

signal interaction_started
signal interaction_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(owner is CharacterBody3D, "InteractionAbilityComponent must be attached to a CharacterBody3D.")
	raycast_interaction.target_position = Vector3.FORWARD * interaction_distance

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if Engine.is_editor_hint() and owner == null:
		return warnings

	if owner is not CharacterBody3D:
		warnings.append("The InteractionAbilityComponent must be a child of the CharacterBody3D.")

	return warnings

func try_interact() -> void:
	raycast_interaction.force_raycast_update()

	if not raycast_interaction.is_colliding():
		interaction_ended.emit()
		return

	var collider := raycast_interaction.get_collider()

	if collider == null:
		interaction_ended.emit()
		return

	var item = collider.owner

	if item is not Interactable:
		interaction_ended.emit()
		return

	item.interaction_started.connect(_on_interaction_started, CONNECT_ONE_SHOT)
	item.interaction_ended.connect(_on_interaction_ended, CONNECT_ONE_SHOT)
	item._interact(owner)

func _on_interaction_started() -> void:
	interaction_started.emit()

func _on_interaction_ended() -> void:
	interaction_ended.emit()
