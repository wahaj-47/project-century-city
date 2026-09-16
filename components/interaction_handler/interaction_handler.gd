@tool
class_name InteractionHandler
extends Node3D

signal interaction_started
signal interaction_ended

func _ready() -> void:
	assert(owner.has_method('on_interaction'))


func interact(_instigator: Node3D) -> void:
	owner.on_interaction(_instigator)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if Engine.is_editor_hint() and owner == null:
		return warnings

	if not owner.has_method('on_interaction'):
		warnings.append('Owner does not have a on_interaction method')

	return warnings