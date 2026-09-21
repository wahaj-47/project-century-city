@tool
extends EditorPlugin

var _camera: Camera3D
var _widget_component: WidgetComponent
var _instantiated_widget: Control
var _viewport_control: Control


func _enter_tree() -> void:
	var viewport := EditorInterface.get_editor_viewport_3d()
	_camera = viewport.get_camera_3d()


func _handles(object: Object) -> bool:
	return object is WidgetComponent


func _edit(object: Object) -> void:
	if object == null:
		return

	_widget_component = object

	if is_instance_valid(_instantiated_widget):
		_instantiated_widget.free()

	if _widget_component.widget == null:
		return

	if _widget_component.widget.scene == null:
		return
	
	_instantiated_widget = _widget_component.widget.instantiate()

	if is_instance_valid(_viewport_control):
		_viewport_control.add_child(_instantiated_widget)


func _make_visible(visible: bool) -> void:
	if is_instance_valid(_instantiated_widget):
		_instantiated_widget.visible = visible


func _forward_3d_draw_over_viewport(viewport_control: Control) -> void:
	_viewport_control = viewport_control
	
	if _instantiated_widget == null:
		return

	var screen_position: Vector2 = _camera.unproject_position(_widget_component.global_position)
	_instantiated_widget.position = screen_position - (_instantiated_widget.get_combined_minimum_size() * _widget_component.pivot)


func _exit_tree() -> void:
	if is_instance_valid(_instantiated_widget):
		_instantiated_widget.queue_free()