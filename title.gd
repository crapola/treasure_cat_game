extends Control

func _on_gui_input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file("res://main.tscn")
