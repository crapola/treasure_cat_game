extends Control

## The material preload scene displays all materials in the game, to force the
## engine into loading them.

@onready var _progress:=$Progress as Label
@onready var _logo:=$Icon

func _ready()->void:
	var t:=_logo.create_tween()
	t.tween_property($Icon,"self_modulate:a",1.0,0.75)
	printerr("Preload scene start.")
	# Go through every particles in the game.
	# It only works with preload(), not load(), so we have to type constant
	# paths.
	const scenes:Array[PackedScene]=[
		preload("res://particles/heal.tscn"),
		preload("res://particles/smoke_puff.tscn"),
		preload("res://particles/sparkles.tscn"),
		]
	for i:int in scenes.size():
		_progress.text=str(round(100*float(i)/float(scenes.size())))+"%"
		await get_tree().process_frame
		var n:Node2D=scenes[i].instantiate() as Node2D
		n.modulate.a=0.1
		n.scale=Vector2.ONE*0.001
		add_child(n)
		for j in 4:
			await get_tree().physics_frame
			await get_tree().process_frame
	printerr("Preload scene stop.")
	# TODO: Why free() doesn't work in export.
	# https://github.com/godotengine/godot/issues/73036
	#free()
	queue_free()
