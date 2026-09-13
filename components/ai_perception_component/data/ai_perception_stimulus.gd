class_name AIPerceptionStimulus
extends RefCounted

enum AIPerceptionStimulusStatus {
	ACTIVE,
	INACTIVE,
}

var status: AIPerceptionStimulusStatus
var receiver_location: Vector3
var stimulus_location: Vector3
var strength: float
var sensor_type: AIPerceptionComponent.AIPerceptionSensorType

func _init(_status: AIPerceptionStimulusStatus, _receiver_location: Vector3, _stimulus_location: Vector3, _strength: float, _sensor_type: AIPerceptionComponent.AIPerceptionSensorType) -> void:
    status = _status
    receiver_location = _receiver_location
    stimulus_location = _stimulus_location
    strength = _strength
    sensor_type = _sensor_type