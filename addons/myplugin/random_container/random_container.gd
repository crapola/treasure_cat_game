@tool
class_name RandomContainer
extends Control

## Random Container
##
## This container randomly positions its child [Control]s within its rectangle.

func _ready()->void:
	# Create a ReferenceRect in the editor to show area.
	if Engine.is_editor_hint():
		var ref_rect:ReferenceRect=ReferenceRect.new()
		add_child(ref_rect)
		ref_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ref_rect.border_width=2
	else:
		_move_content()

func _move_content()->void:
	for n in get_children():
		var c:Control=n as Control
		if c and c is not ReferenceRect:
			_reposition(c)

func _reposition(control:Control)->void:
	var r:Rect2=control.get_rect()
	control.position=Vector2(randf_range(0,size.x-r.size.x),randf_range(0,size.y-r.size.y))
