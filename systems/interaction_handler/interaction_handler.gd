@tool
class_name InteractionHandler
extends Area3D

@export var enabled := true

signal interaction_started
signal interaction_ended


func try_interact(instigator: Node3D) -> void:
	interaction_started.emit()

	if not _can_interact(): 
		_end_interaction()
		return

	_interact(instigator)


func _can_interact() -> bool:
	return enabled


## Actual interaction logic should be implemented in the subclass
func _interact(instigator: Node3D) -> void:
	pass


## Call this function to end the interaction and emit the signal. This should be called by the subclass when the interaction is finished.
func _end_interaction() -> void:
	interaction_ended.emit()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if Engine.is_editor_hint() and owner == null:
		return warnings

	return warnings


func set_prompt_visible(value: bool) -> void:
	if not enabled: return
	$WidgetComponent.visible = value