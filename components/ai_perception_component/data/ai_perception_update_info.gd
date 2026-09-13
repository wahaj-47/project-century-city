class_name AIPerceptionUpdateInfo
extends RefCounted

var target: Node3D
var stimulus: AIPerceptionStimulus

func _init(_target: Node3D, _stimulus: AIPerceptionStimulus) -> void:
    target = _target
    stimulus = _stimulus