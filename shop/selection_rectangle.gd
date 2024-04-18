extends ColorRect

## Animated mouse hovering effect.

var _tween:Tween

func _init()->void:
	size=Vector2(0,0)
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	visible=false

func highlight(control:Control)->void:
	size=control.get_rect().size
	color.a=0.5
	scale=Vector2.ONE*0.5
	pivot_offset=size/4.0
	const t:float=4/60.0#0.125
	if _tween:_tween.stop()
	_tween=create_tween()
	_tween.set_parallel()
	if visible:
		_tween.tween_property(self,"global_position",control.global_position,t)
	else:
		global_position=control.global_position
	_tween.tween_property(self,"scale",Vector2.ONE,t)
	_tween.tween_property(self,"color:a",0.125,t*2.0)
	visible=true

func collapse()->void:
	if _tween:_tween.stop()
	visible=false
