class_name Cat
extends Actor

signal collide_shop # -> main.shop_open()

@onready var animation:=$CatArea/AnimationPlayer

func _ready()->void:
	super._ready()
	# Head swinging loop.
	rotation=-0.10
	var t:=create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.tween_property(self,"rotation",0.10,2.0)
	t.tween_property(self,"rotation",-0.10,2.0)
	t.set_loops(0)

func _physics_process(delta:float)->void:
	super._physics_process(delta)
	# Mouse control.
	var mouse_pos:Vector2=get_viewport().get_mouse_position()
	var displace:Vector2=mouse_pos-position
	const speed:float=128
	if displace.length()>delta*speed:
		velocity_component.accelerate(displace.normalized()*speed,0.50)
	else:
		velocity_component.acceleration=Vector2.ZERO
		velocity_component.velocity=Vector2.ZERO
		position=mouse_pos

func _CatArea_on_area_entered(area:Area2D)->void:
	var shop:Shop=area.owner as Shop
	if shop:
		collide_shop.emit(shop)
		return
	var actor:=area.owner as Actor
	if not actor:
		return
