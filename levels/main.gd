## Initializes the game state
extends Node

@onready var player: Character = $Player
@onready var map: AStarGridMap = $Map

func _ready() -> void:
	assert(player != null, "Player character not found.")
	GameState.player = player

	assert(map != null, "AStarGridMap not found.")
	GameState.map = map

	for node in get_tree().get_nodes_in_group("Solid"):
		map.set_point_solid(node.global_position, true)
