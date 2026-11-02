extends Node

enum ActorType {NONE, PLAYER, ENEMY}
enum NavigationState {BLOCKED, OPEN}
var tile_size: float = 1.0