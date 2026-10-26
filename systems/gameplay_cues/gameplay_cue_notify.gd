class_name GameplayCueNotify 
extends Node

signal cue_finished(cue_node: GameplayCueNotify)

@export_category("Lifecycle")
## If true, this node will automatically pool itself after playing.
## (Set to false for looping effects like a glowing aura).
@export var auto_destroy: bool = true
## How long to wait before pooling this node. 
## Set this slightly longer than your longest particle/audio duration.
@export var destroy_delay: float = 2.0

## Called by the Manager when pulled from the pool and added to the target.
func execute_cue(parameters: GameplayCueParameters) -> void:
	# 1. Trigger the visual/audio logic
	play_cue(parameters)
	
	# 2. Setup the automatic garbage collection (Pooling)
	if auto_destroy:
		# We use a safe Godot 4 timer connection to finish the cue instead of queue_free
		get_tree().create_timer(destroy_delay).timeout.connect(finish_cue)


## For persistent cues, called by the Manager when the effect is removed.
## Override this in inherited scripts to play fade-out animations, then call finish_cue() when done.
func end_cue() -> void:
	finish_cue()


## Call this from your inherited scripts when the visual/audio effect is 100% done.
## (e.g., hook this up to the 'finished' signal of an AudioStreamPlayer or a Timer).
func finish_cue() -> void:
	# Emits the signal so the Manager pulls it off the target and puts it back to sleep
	cue_finished.emit(self)


## Virtual internal method. Override this in your specific effect scripts if you need custom logic.
## (e.g., attaching to a specific bone on a 3D model, or playing a specific AnimationTree).
func play_cue(parameters: GameplayCueParameters) -> void:
	# By default, if you have an AnimationPlayer, you could auto-play an 'Activate' animation here.
	pass