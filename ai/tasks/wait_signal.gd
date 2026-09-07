@tool
extends BTAction

@export var signal_source: NodePath
@export var signal_name: String

var signal_received: bool = false

# Called when the node enters the scene tree for the first time.
func _setup() -> void:
	assert(signal_source != null, "Signal source is not set.")
	assert(signal_name != null, "Signal name is not set.")
	
	var signal_source_node = agent.get_node(signal_source)
	assert(signal_source_node != null, "Signal source node not found.")
	
	signal_source_node.connect(signal_name, _on_signal_received)

func _enter() -> void:
	signal_received = false

func _on_signal_received() -> void:
	signal_received = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _tick(delta: float) -> Status:
	if signal_received:
		return SUCCESS

	return RUNNING


# Strings returned from this method are displayed as warnings in the behavior tree editor (requires @tool).
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if signal_source.is_empty():
		warnings.append("Signal source is empty.")
	if signal_name.is_empty():
		warnings.append("Signal name is empty.")

	return warnings
