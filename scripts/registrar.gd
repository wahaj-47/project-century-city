extends Node

@export var key: StringName
@export var registered_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Blackboard.register(key, registered_node)
