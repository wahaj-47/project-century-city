class_name WaitingForTurn
extends BTState

@export var interaction_handler: InteractionHandler


func _enter() -> void:
	if interaction_handler != null: interaction_handler.enabled = true


func _exit() -> void:
	if interaction_handler != null: interaction_handler.enabled = false

