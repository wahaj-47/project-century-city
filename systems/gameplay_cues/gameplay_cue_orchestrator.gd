# Executes a gameplay cue
# This only exists as an intermediary to the autoloaded GameplayCueManager
# The autoloaded GameplayCueManager is responsible for actually executing the cue
# It was done this way to allow cues to be potentially pooled and reused
extends Node

func execute_cue(gameplay_cue: GameplayCue) -> void:
	GameplayCueManager.execute_cue(gameplay_cue)
