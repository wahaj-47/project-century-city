@tool
class_name InteractionHandler
extends Node3D

@export var enabled := true

signal interaction_started
signal interaction_ended


## Actual interaction logic should be implemented in the subclass
func interact(instigator: Node3D) -> void:
	if not enabled:
		return


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if Engine.is_editor_hint() and owner == null:
		return warnings

	return warnings