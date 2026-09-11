# We need to replace this with a BTTask because we need to check at the end of turn if the player can be killed
extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		owner.kill_player = true

func _on_body_exit(body: Node3D) -> void:
	if body is Player:
		owner.kill_player = false