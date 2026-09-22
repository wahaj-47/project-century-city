class_name AIPerceptionInfo
extends RefCounted

var target: Node3D
var stimuli: Dictionary[AIPerceptionComponent.AIPerceptionSensorType, AIPerceptionStimulus] = {}

func _init(_target: Node3D) -> void:
    target = _target

func is_perceived() -> bool:
    for stimulus in stimuli.values():
        if stimulus.status == AIPerceptionStimulus.AIPerceptionStimulusStatus.ACTIVE:
            return true

    return false
