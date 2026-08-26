extends StaticBody3D
var isDoorOpen = false
var doorIsMoving = false
var movementAmount = 15

func flipDoor():
	doorIsMoving = not doorIsMoving

func interact():
	if doorIsMoving:
		return
	flipDoor()
	var curPos = global_position
	
	var tween = create_tween()
	if not isDoorOpen:
		tween.tween_property(self, "global_position", Vector3(curPos.x, curPos.y+movementAmount, curPos.z), 1.0)
	else:
		tween.tween_property(self, "global_position", Vector3(curPos.x, curPos.y-movementAmount, curPos.z), 1.0)
		
	tween.tween_callback(flipDoor)
	isDoorOpen = not isDoorOpen
	
		
