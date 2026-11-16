extends LimboState

var _actor: Character
var _path: PackedVector3Array
var _step: int = 1;


func _enter() -> void:
	_actor = agent as Character
	_step = 1
	_path = blackboard.get_var("path")

	if _path.size() < 1:
		push_error("Path is empty.")
		dispatch(&'movement_ended')
		return

	_actor.apply_movement(_path[_step], true, _on_movement_finished)


func _on_movement_finished() -> void:
	_step += 1
	
	if _step < _path.size(): _actor.apply_movement(_path[_step], true, _on_movement_finished)
	else: _actor.end_turn(_path.size() - 1)
