extends Behaviour

## Ghost fading.

# Player location.
var _revealer:Node2D

func _ready()->void:
	super._ready()
	_actor.health_changed.connect(on_hit)
	_actor.gold_collected.connect(func(_gold:int)->void:
		set_opacity(0.25)
		tween_opacity(0.5))
	tween_opacity(4)

func _process(_delta:float)->void:
	if _revealer:
		var distance:float=_actor.global_position.distance_to(_revealer.global_position)
		var opacity=1.0-distance/128.0 # FIXME Radius of collision shape.
		set_opacity(opacity)

func on_hit(_hp:int)->void:
	tween_opacity(5)

func set_opacity(opacity:float)->void:
	_actor.sprite.modulate.a=opacity

func tween_opacity(duration:float)->void:
	set_opacity(1.0)
	var t=create_tween()
	t.tween_method(set_opacity,1.0,0.0,duration)

func _reveal_area_entered(area:Area2D)->void:
	_revealer=area

func _reveal_area_exited(_area:Area2D)->void:
	_revealer=null
