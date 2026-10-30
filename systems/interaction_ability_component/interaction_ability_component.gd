@tool
class_name InteractionAbilityComponent
extends Node3D

@export var enabled := true

signal interaction_started
signal interaction_ended


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(owner is CharacterBody3D, "InteractionAbilityComponent must be attached to a CharacterBody3D.")


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if Engine.is_editor_hint() and owner == null:
		return warnings

	if owner is not CharacterBody3D:
		warnings.append("The InteractionAbilityComponent must be a child of the CharacterBody3D.")

	return warnings


func try_interact(interaction_target: InteractionHandler) -> bool:
	if not enabled: return false
	if interaction_target == null: return false

	interaction_target.interaction_started.connect(_on_interaction_started, CONNECT_ONE_SHOT)
	interaction_target.interaction_ended.connect(_on_interaction_ended, CONNECT_ONE_SHOT)
	interaction_target.interact(owner)
	return true


func _on_interaction_started() -> void:
	interaction_started.emit()


func _on_interaction_ended() -> void:
	interaction_ended.emit()
