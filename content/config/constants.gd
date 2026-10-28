extends Node

enum ActorType {NONE, PLAYER, ENEMY}
var tile_size: float = 1.0

const TILE_HIGHLIGHT: PackedScene = preload("res://content/targeting/tile_highlight.tscn")
