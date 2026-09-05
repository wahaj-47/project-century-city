# Switches player to the target camera when the player enters the entry point.
extends Area3D

@export var target_camera: Camera3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target_camera.make_current()
