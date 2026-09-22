class_name AIPerceptionStimulusToProcess
extends RefCounted

var source: Node3D
var stimulus: AIPerceptionStimulus

func _init(_source: Node3D, _stimulus: AIPerceptionStimulus) -> void:
    source = _source
    stimulus = _stimulus