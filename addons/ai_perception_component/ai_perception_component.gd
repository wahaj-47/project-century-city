class_name AIPerceptionComponent
extends Node3D

enum AIPerceptionSensorType {
	PROXIMITY,
	VISION,
	HEARING,
	TOUCH,
}

signal perception_updated(nearby_entities: Array[Node3D])
signal target_perception_info_updated(update_info: AIPerceptionUpdateInfo)
signal target_perception_updated(target: Node3D, stimulus: AIPerceptionStimulus)

var stimuli_to_process: Array[AIPerceptionStimulusToProcess] = []
var perceptual_data: Dictionary[Node3D, AIPerceptionInfo] = {}

func _ready():
	var children = get_children()
	for child in children:
		if "sensor_type" not in child:
			continue

		var sensor = child
		match sensor.sensor_type:
			AIPerceptionSensorType.PROXIMITY:
				register_proximity_sensor(sensor)


func _physics_process(_delta: float) -> void:
	process_stimuli()


func process_stimuli() -> void:
	if stimuli_to_process.size() == 0:
		return

	var entities_updated: int = 0
	for stimulus_to_process in stimuli_to_process:
		var source = stimulus_to_process.source
		var stimulus = stimulus_to_process.stimulus

		var perception_info: AIPerceptionInfo = perceptual_data.get(source)

		if perception_info == null:
			perception_info = AIPerceptionInfo.new(source)
			perceptual_data[source] = perception_info

		var perception_changed = false
		var stimulus_store = perception_info.stimuli.get(stimulus.sensor_type)

		if stimulus_store == null or stimulus_store.status != stimulus.status:
			perception_changed = true
		
		perception_info.stimuli[stimulus.sensor_type] = stimulus

		if perception_changed:
			entities_updated += 1
			var update_info = AIPerceptionUpdateInfo.new(source, stimulus)
			emit_signal("target_perception_info_updated", update_info)
			emit_signal("target_perception_updated", source, stimulus)
	
	stimuli_to_process.clear()

	if entities_updated > 0:
		var nearby_entities = get_currently_perceived_entities()
		emit_signal("perception_updated", nearby_entities)
		

func is_target_perceived(target: Node3D) -> bool:
	return perceptual_data.has(target) and perceptual_data[target].is_perceived()


func get_currently_perceived_entities() -> Array[Node3D]:
	var result: Array[Node3D] = []

	for source in perceptual_data:
		var info: AIPerceptionInfo = perceptual_data[source]
		if info.is_perceived():
			result.append(source)

	return result


func get_filtered_entities(predicate: Callable) -> Array[Node3D]:
	var result: Array[Node3D] = []
	for source in perceptual_data:
		var info: AIPerceptionInfo = perceptual_data[source]
		if info.is_perceived() and predicate.call(source):
			result.append(source)
	return result


func has_filtered_entities(predicate: Callable) -> bool:
	for source in perceptual_data:
		var info: AIPerceptionInfo = perceptual_data[source]
		if info.is_perceived() and predicate.call(source):
			return true
	return false


func register_proximity_sensor(sensor: AIProximitySensor) -> void:
	sensor.connect("body_entered", _on_body_enter_proximity)
	sensor.connect("body_exited", _on_body_exit_proximity)


func _on_body_enter_proximity(body: Node3D) -> void:
	if body == owner:
		return

	var stimulus = AIPerceptionStimulus.new(
		AIPerceptionStimulus.AIPerceptionStimulusStatus.ACTIVE,
		owner.global_transform.origin,
		body.global_transform.origin,
		1.0,
		AIPerceptionComponent.AIPerceptionSensorType.PROXIMITY)

	var stimulus_to_process = AIPerceptionStimulusToProcess.new(body, stimulus)
	stimuli_to_process.append(stimulus_to_process)


func _on_body_exit_proximity(body: Node3D) -> void:
	if body == owner:
		return

	var stimulus = AIPerceptionStimulus.new(
		AIPerceptionStimulus.AIPerceptionStimulusStatus.INACTIVE,
		owner.global_transform.origin,
		body.global_transform.origin,
		0.0,
		AIPerceptionComponent.AIPerceptionSensorType.PROXIMITY)

	var stimulus_to_process = AIPerceptionStimulusToProcess.new(body, stimulus)
	stimuli_to_process.append(stimulus_to_process)
