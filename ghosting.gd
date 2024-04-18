extends Behaviour

## Ghost fading.

func _ready()->void:
	super._ready()
	print_debug(_actor.sprite)
	_actor.health_changed.connect(on_hit)
	_actor.gold_collected.connect(func(_gold:int)->void:
		set_opacity(0.25)
		tween_opacity(0.5)
		)
	tween_opacity(4)

func on_hit(_hp:int)->void:
	tween_opacity(5)

func set_opacity(opacity:float)->void:
	_actor.sprite.modulate.a=opacity

func tween_opacity(duration:float)->void:
	set_opacity(1.0)
	var t=create_tween()
	t.tween_method(set_opacity,1.0,0.0,duration)
