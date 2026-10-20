@tool
extends Node

@export var sprite3d: Sprite3D
@export var animation_player: AnimationPlayer

@export_category("Animation Config")
@export var animation_name: StringName = &"default"
@export var library_name: StringName = &"[Global]"
@export_range(1.0, 60.0, 1.0) var fps: float = 12.0
@export var loop_mode := Animation.LOOP_LINEAR

@export_category("Driver")
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var animation_driver: NodePath
@export_tool_button("Select Driver", "Animation")
var pick_driver_action = pick_property.bind(&"animation_driver")

@export_category("Root Motion")
@export var enable_root_motion: bool = false
@export_file("*.json") var root_motion_json: String
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var root_motion_driver: NodePath
@export_tool_button("Select Driver", "Animation")
var pick_root_motion_driver_action  = pick_property.bind(&"root_motion_driver")

@export_category("Actions")
@export_tool_button("Generate Animation", "Animation")
var generate_animation_action = generate_animation


func pick_property(target: StringName) -> void:
	EditorInterface.popup_property_selector(
		sprite3d,
		_on_property_selected.bind(target),
		[],
	)


func _on_property_selected(property_path: NodePath, target: StringName) -> void:
	if property_path.is_empty():
		return

	var full_path = NodePath(str(get_path_to(sprite3d)) + str(property_path.get_as_property_path()))
	set(target, full_path)


func generate_animation() -> void:
	if fps <= 0.0:
		push_error("FPS must be greater than 0.")
		return

	var library: AnimationLibrary

	if animation_player.has_animation_library(library_name):
		library = animation_player.get_animation_library(library_name)
	else:
		library = AnimationLibrary.new()
		animation_player.add_animation_library(library_name, library)

	if library.has_animation(animation_name):
		library.remove_animation(animation_name)

	var path_to_sprite3d = str(get_path_to(sprite3d))
	var animation := Animation.new()

	var hframes_track := animation.add_track(Animation.TYPE_VALUE)

	animation.track_insert_key(
		hframes_track,
		0.0,
		sprite3d.hframes
	)

	animation.track_set_path(
		hframes_track,
		NodePath(path_to_sprite3d +":hframes")
	)
	
	var texture_track := animation.add_track(Animation.TYPE_VALUE)

	animation.track_set_path(
		texture_track,
		NodePath(path_to_sprite3d +":texture")
	)

	animation.track_insert_key(
		texture_track,
		0.0,
		sprite3d.texture
	)

	var frame_count := sprite3d.hframes
	var frame_duration := 1.0 / fps

	animation.length = (frame_count - 1) * frame_duration
	animation.loop_mode = loop_mode

	var animation_track := animation.add_track(Animation.TYPE_VALUE)

	animation.track_set_path(
		animation_track,
		animation_driver
	)

	animation.track_set_interpolation_type(
		animation_track,
		Animation.INTERPOLATION_NEAREST
	)

	for anim_frame in range(frame_count):
		animation.track_insert_key(
			animation_track,
			anim_frame * frame_duration,
			anim_frame
		)

	if enable_root_motion and not root_motion_json.is_empty():
		var data = JSON.parse_string(FileAccess.get_file_as_string(root_motion_json))
		var frames = data.frames
		print(frames.size())
		var root_motion_track := animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(
			root_motion_track,
			root_motion_driver
		)
		animation.value_track_set_update_mode(
			root_motion_track, 
			Animation.UPDATE_DISCRETE
		)
		for anim_frame in range(frame_count):
			var frame = frames[anim_frame]
			animation.track_insert_key(
				root_motion_track,
				anim_frame * frame_duration,
				Vector3(frame[0], frame[1], frame[2]) * sprite3d.pixel_size
			)

	library.add_animation(animation_name, animation)
	
	print(
		"Generated '%s' — %d frames @ %.1f FPS"
		% [animation_name, frame_count, fps]
	)