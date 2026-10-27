# Executes a gameplay cue
# This only exists as an intermediary to the autoloaded GameplayCueManager
# The autoloaded GameplayCueManager is responsible for actually executing the cue
# It was done this way to allow cues to be potentially pooled and reused
extends Node

@export var cue_target: NodePath

func execute_cue(gameplay_cue_event: GameplayCueEvent) -> void:
	var parameters = GameplayCueParameters.new()
	var target = get_node(cue_target)

	parameters.location = target.to_global(gameplay_cue_event.location_offset)

	GameplayCueManager.execute_cue(target, gameplay_cue_event, parameters)
