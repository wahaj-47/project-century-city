extends Node

func execute_cue(target: Node, gameplay_cue: GameplayCue, parameters: GameplayCueParameters) -> void:
	var instance = gameplay_cue.scene.instantiate()
	
	if not instance is GameplayCueNotify:
		push_error("GameplayCue '%s' must extend GameplayCueNotify" % gameplay_cue.scene.resource_name)
		instance.free()
		return

	var cue_instance = instance as GameplayCueNotify
	target.add_child(cue_instance)
	cue_instance.cue_finished.connect(on_cue_finished)
	cue_instance.execute_cue(parameters)


func on_cue_finished(cue_node: GameplayCueNotify) -> void:
	cue_node.queue_free()
