extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body == owner:
		pass
	elif body is Player:
		owner.player_detected = true
	elif body is Enemy:
		owner.num_enemies_detected += 1
	

func _on_body_exited(body: Node3D) -> void:
	if body is Enemy:
		owner.num_enemies_detected -= 1
		# If no other enemies nearby then player is also no longer nearby
		if owner.num_enemies_detected == 0:
			owner.player_detected = false
