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

	for node in get_tree().get_nodes_in_group("Navigation"):
		var interactable = node as InteractionHandlerNavigation
		map.set_point_solid(interactable.global_position, interactable.state == Constants.NavigationState.BLOCKED)
		interactable.state_changed.connect(on_navigation_state_changed)


func on_navigation_state_changed(node: InteractionHandlerNavigation, state: Constants.NavigationState) -> void:
	map.set_point_solid(node.global_position, node.state == Constants.NavigationState.BLOCKED)


func _unhandled_input(event: InputEvent) -> void:
	game.push_input(event)
