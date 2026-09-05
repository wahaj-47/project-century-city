extends LimboState

func _enter() -> void:
	dispatch(&'turn_started')
