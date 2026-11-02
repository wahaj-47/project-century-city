@tool
class_name InteractionHandlerNavigation
extends InteractionHandler

signal state_changed(node: Node3D, state: Constants.NavigationState)

@export var state: Constants.NavigationState = Constants.NavigationState.BLOCKED

var animating = false


func can_interact() -> bool:
	return not animating


func interact(instigator: Node3D) -> void:
	super.interact(instigator)
	interaction_started.emit()
	animating = true
	
	match state:
		Constants.NavigationState.BLOCKED: open(instigator)
		Constants.NavigationState.OPEN: close()


func end_interaction() -> void:
	super.end_interaction()
	animating = false
	state = Constants.NavigationState.OPEN if state == Constants.NavigationState.BLOCKED else Constants.NavigationState.BLOCKED
	state_changed.emit(self, state)
	

func open(instigator: Node3D) -> void:
	pass

func close() -> void:
	pass