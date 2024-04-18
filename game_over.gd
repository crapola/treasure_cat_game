extends Control

func _on_gui_input(event:InputEvent)->void:
	var mouse_button:InputEventMouseButton=event as InputEventMouseButton
	if mouse_button and mouse_button.button_index==MOUSE_BUTTON_LEFT and mouse_button.pressed==false:
		get_tree().change_scene_to_file("res://main.tscn")
