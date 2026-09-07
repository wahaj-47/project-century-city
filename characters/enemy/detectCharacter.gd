extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(owner.name, " ", numBodiesInArea)
	pass


func _on_body_entered(body: Node3D) -> void:
	if body == owner:
		pass
	elif body is Player:
		owner.playerDetected = true
	elif body is Enemy:
		owner.numEnemiesDetected += 1
	

func _on_body_exited(body: Node3D) -> void:
	if body is Enemy:
		owner.numEnemiesDetected -= 1
		# If no other enemies nearby then player is also no longer nearby
		if owner.numEnemiesDetected == 0:
			owner.playerDetected = false
