extends Node3D
class_name WidgetComponent

enum Display {
	WORLD,
	SCREEN
}

## The coordinate space in which to render the widget (World or Screen). 
## With World the widget is rendered in the world as a mesh  and can be occluded.
## While Screen renders the widget on the screen completely outside of the world and is never occluded.
@export var space: Display = Display.SCREEN

## The scene to be instantiated and displayed.
@export var widget: Widget:
	set(value):
		widget = value
		notify_property_list_changed()

## The Alignment/Pivot point that the widget is placed at relative to the position.
@export var pivot: Vector2 = Vector2.ZERO

## Should the Widget wait to be told to redraw to actually draw or not.
@export var manually_redraw: bool = false

var _instantiated_widget: Control
var _camera: Camera3D


func _ready() -> void:
	if widget == null:
		return
	
	_camera = get_viewport().get_camera_3d()

	_instantiated_widget = widget.instantiate()
	add_child(_instantiated_widget)
	_instantiated_widget.owner = self
	

func _process(delta: float) -> void:
	if _instantiated_widget == null:
		return
	
	if _camera == null:
		return

	if _camera.is_position_behind(global_position) or not visible:
		# Hide the widget
		_instantiated_widget.hide()
		return

	var screen_position: Vector2 = _camera.unproject_position(global_position)
	_instantiated_widget.position = screen_position - (_instantiated_widget.size * pivot)
	_instantiated_widget.show()
