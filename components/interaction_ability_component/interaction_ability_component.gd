@tool
class_name InteractionAbilityComponent
extends Node3D

@export var target_query: TargetQuery

signal interaction_started
signal interaction_ended

var current_interaction_target: InteractionHandler:
	set(value):
		if current_interaction_target == value:
			return

		if current_interaction_target != null:
			current_interaction_target.set_prompt_visible(false)
		
		if value != null:
			value.set_prompt_visible(true)
		
		current_interaction_target = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(owner is CharacterBody3D, "InteractionAbilityComponent must be attached to a CharacterBody3D.")


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if target_query == null:
		return

	var query_result := target_query.find_target(self)
	current_interaction_target = query_result.get("collider") as InteractionHandler


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if Engine.is_editor_hint() and owner == null:
		return warnings

	if owner is not CharacterBody3D:
		warnings.append("The InteractionAbilityComponent must be a child of the CharacterBody3D.")

	return warnings


func try_interact() -> void:
	if current_interaction_target == null:
		interaction_ended.emit()
		return

	current_interaction_target.interaction_started.connect(_on_interaction_started, CONNECT_ONE_SHOT)
	current_interaction_target.interaction_ended.connect(_on_interaction_ended, CONNECT_ONE_SHOT)
	current_interaction_target.interact(owner)


func _on_interaction_started() -> void:
	interaction_started.emit()


func _on_interaction_ended() -> void:
	interaction_ended.emit()
