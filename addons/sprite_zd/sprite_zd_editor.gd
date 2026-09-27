@tool
extends EditorPlugin

const SpriteZDInspectorPlugin = preload("res://addons/sprite_zd/sprite_zd_inspector.gd")

var inspector_plugin: SpriteZDInspectorPlugin


func _enter_tree() -> void:
	inspector_plugin = SpriteZDInspectorPlugin.new()
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)
	inspector_plugin = null