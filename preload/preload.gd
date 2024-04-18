extends Node

## Shader/material preload autoload for the web version.

const PRELOAD_SCENE:String="res://preload/preload.tscn"

func _ready()->void:
	if OS.get_name()=="Web":# or true:
		print_debug("Platform is Web.")
		# Must wait a bit.
		await get_tree().process_frame
		get_tree().change_scene_to_file(PRELOAD_SCENE)
		get_tree().get_root().child_exiting_tree.connect(
		func(_n:Node)->void:
			var main:String=ProjectSettings.get_setting("application/run/main_scene")
			get_tree().change_scene_to_file(main)
		,CONNECT_ONE_SHOT)
