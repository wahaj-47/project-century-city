## Initializes the game state
extends Node

@export var map: AStarGridMap
@export var game: SubViewport


func _ready() -> void:
	assert(map != null, "AStarGridMap not found.")
	Constants.tile_size = map.cell_size.x

	var character_config = CharacterConfig.new()
	character_config.map = map

	for node in get_tree().get_nodes_in_group("Pawn"):
		node.initialize(character_config)

	for node in get_tree().get_nodes_in_group("Solid"):
		map.set_point_solid(node.global_position, true)


func _unhandled_input(event: InputEvent) -> void:
	game.push_input(event)
