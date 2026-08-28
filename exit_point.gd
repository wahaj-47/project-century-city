extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	print("in trigger")
	if body.is_in_group("Player"):
		get_tree().quit()
