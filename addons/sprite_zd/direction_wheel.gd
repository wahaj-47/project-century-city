@tool
extends Control

## Draggable direction wheel for the inspector, shown under a SpriteZD node.
## Sector boundaries are the angular midpoints between neighboring entries in
## direction_mapping, so it works for any direction count or spacing rather
## than assuming an even split.

const RADIUS := 100.0
const PREVIEW_SIZE := 44.0

var sprite_node: SpriteZD
var test_direction: Vector2 = Vector2.DOWN
var dragging: bool = false


func setup(node: SpriteZD) -> void:
	sprite_node = node
	custom_minimum_size = Vector2(260, 260)
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)


func _process(_delta: float) -> void:
	if is_instance_valid(sprite_node):
		queue_redraw()
	else:
		set_process(false)


func _get_sorted_entries() -> Array:
	var entries: Array = []
	if not is_instance_valid(sprite_node):
		return entries

	for key in sprite_node.direction_mapping.keys():
		var v: Vector2 = Vector2(key.x, key.y) if key is Vector2i else key
		if v.length() < 0.0001:
			continue
		entries.append({"vector": v, "angle": v.angle(), "index": sprite_node.direction_mapping[key]})

	entries.sort_custom(func(a, b): return a.angle < b.angle)
	return entries


func _get_frame_rect(index: int) -> Rect2:
	var tex := sprite_node.texture
	var hframes := maxi(sprite_node.hframes, 1)
	var vframes := maxi(sprite_node.vframes, 1)
	var cell := Vector2(tex.get_width() / float(hframes), tex.get_height() / float(vframes))

	var coords := sprite_node.frame_coords
	match sprite_node.direction_dimension:
		SpriteZD.DirectionDimension.X:
			coords.x = index
		SpriteZD.DirectionDimension.Y:
			coords.y = index

	return Rect2(coords.x * cell.x, coords.y * cell.y, cell.x, cell.y)


func _draw() -> void:
	if not is_instance_valid(sprite_node):
		return

	var center := size / 2.0
	draw_line(center - Vector2(RADIUS + 10, 0), center + Vector2(RADIUS + 10, 0), Color(1, 1, 1, 0.12), 1.0)
	draw_line(center - Vector2(0, RADIUS + 10), center + Vector2(0, RADIUS + 10), Color(1, 1, 1, 0.12), 1.0)

	var entries := _get_sorted_entries()
	if entries.is_empty():
		draw_string(ThemeDB.fallback_font, center - Vector2(70, 0), "direction_mapping is empty", HORIZONTAL_ALIGNMENT_CENTER, 140)
		return

	var n := entries.size()

	# Nearest-angle match, same rule the SpriteZD dot-product version uses.
	var active_index := -1
	var closest_dot := -INF
	for e in entries:
		var d: float = test_direction.normalized().dot(e.vector.normalized())
		if d > closest_dot:
			closest_dot = d
			active_index = e.index

	var has_texture: bool = sprite_node.texture != null

	for i in range(n):
		var prev_angle: float = entries[(i - 1 + n) % n].angle
		var curr_angle: float = entries[i].angle
		var next_angle: float = entries[(i + 1) % n].angle

		# Unwrap around the seam so midpoints are computed on a continuous range.
		if prev_angle > curr_angle:
			prev_angle -= TAU
		if next_angle < curr_angle:
			next_angle += TAU

		var start_angle: float = (prev_angle + curr_angle) / 2.0
		var end_angle: float = (curr_angle + next_angle) / 2.0

		var points := PackedVector2Array()
		points.append(center)
		var steps := 10
		for s in range(steps + 1):
			var a: float = lerp(start_angle, end_angle, float(s) / steps)
			points.append(center + Vector2(cos(a), sin(a)) * RADIUS)

		var is_active = entries[i].index == active_index
		var fill_color := Color(0.35, 0.6, 1.0, 0.35) if is_active else Color(1, 1, 1, 0.04)
		draw_colored_polygon(points, fill_color)
		draw_polyline(points, Color(1, 1, 1, 0.2), 1.0, true)

		var mid: float = (start_angle + end_angle) / 2.0
		var preview_center := center + Vector2(cos(mid), sin(mid)) * (RADIUS * 0.65)
		var dest := Rect2(preview_center - Vector2(PREVIEW_SIZE, PREVIEW_SIZE) / 2.0, Vector2(PREVIEW_SIZE, PREVIEW_SIZE))

		if has_texture:
			var src := _get_frame_rect(entries[i].index)
			draw_texture_rect_region(sprite_node.texture, dest, src)
			draw_rect(dest, Color(1, 1, 1, 0.5) if is_active else Color(1, 1, 1, 0.15), false, 1.0)
		else:
			draw_string(ThemeDB.fallback_font, dest.position + Vector2(dest.size.x / 2.0 - 6, dest.size.y / 2.0 + 4), str(entries[i].index), HORIZONTAL_ALIGNMENT_CENTER)

	var handle_pos := center + test_direction.normalized() * RADIUS
	draw_line(center, handle_pos, Color(0.35, 0.6, 1.0, 1.0), 2.0)
	draw_circle(handle_pos, 6.0, Color(0.35, 0.6, 1.0, 1.0))

	var deg := roundi(rad_to_deg(test_direction.angle()))
	draw_string(ThemeDB.fallback_font, Vector2(4, size.y - 6), "angle %d\u00b0  frame %d" % [deg, active_index], HORIZONTAL_ALIGNMENT_LEFT, size.x, 12)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			_update_direction(event.position)
	elif event is InputEventMouseMotion and dragging:
		_update_direction(event.position)


func _update_direction(mouse_pos: Vector2) -> void:
	var center := size / 2.0
	var v := mouse_pos - center
	if v.length() < 4.0:
		return

	test_direction = v.normalized()

	# Drive the real node too, so the 3D viewport updates as you drag.
	if is_instance_valid(sprite_node) and sprite_node.has_method("set_directionality"):
		sprite_node.set_directionality(test_direction)

	queue_redraw()