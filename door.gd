extends StaticBody3D
var isDoorOpen = false
var movementAmount = 15

func interact():
	var curPos = global_position
	print("curPos = ", curPos.y)
	var tween = create_tween()
	if not isDoorOpen:
		tween.tween_property(self, "position", Vector3(curPos.x, curPos.y+movementAmount, curPos.z), 1.0)
	else:
		tween.tween_property(self, "position", Vector3(curPos.x, curPos.y-movementAmount, curPos.z), 1.0)
	
	isDoorOpen = not isDoorOpen
	print(isDoorOpen)
	
