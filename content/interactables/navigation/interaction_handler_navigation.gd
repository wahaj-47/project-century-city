@tool
class_name InteractionHandlerNavigation
extends InteractionHandler

signal state_changed(node: Node3D, state: Constants.NavigationState)

@export var state: Constants.NavigationState = Constants.NavigationState.BLOCKED

var animating = false


func _can_interact() -> bool:
	return super._can_interact() and not animating


func _interact(instigator: Node3D) -> void:
	animating = true
	
	match state:
		Constants.NavigationState.BLOCKED: open(instigator)
		Constants.NavigationState.OPEN: close()


func _end_interaction() -> void:
	super._end_interaction()
	animating = false
	state = Constants.NavigationState.OPEN if state == Constants.NavigationState.BLOCKED else Constants.NavigationState.BLOCKED
	state_changed.emit(self, state)
	

func open(instigator: Node3D) -> void:
	pass


func close() -> void:
	pass