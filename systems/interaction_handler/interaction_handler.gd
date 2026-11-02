@tool
class_name InteractionHandler
extends Area3D

@export var enabled := true

signal interaction_started
signal interaction_ended


func can_interact() -> bool:
	return true


## Actual interaction logic should be implemented in the subclass
func interact(instigator: Node3D) -> void:
	if not enabled:return
	if not can_interact(): return


## Call this function to end the interaction and emit the signal. This should be called by the subclass when the interaction is finished.
func end_interaction() -> void:
	interaction_ended.emit()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if Engine.is_editor_hint() and owner == null:
		return warnings

	return warnings


func set_prompt_visible(value: bool) -> void:
	if not enabled: return
	$WidgetComponent.visible = value