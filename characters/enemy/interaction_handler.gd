@tool
extends InteractionHandler

func interact(instigator: Node3D) -> void:
	super.interact(instigator)

	interaction_started.emit()
	print("Interacted with enemy")
	interaction_ended.emit()
