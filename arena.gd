class_name Arena
extends Area2D

## Game arena.
##
## Rectangular game arena.

var _rect:Rect2

class Circle:
	var position:Vector2
	var radius:float
	func _init(p:Vector2,r:float)->void:
		position=p
		radius=r

func _ready()->void:
	const m:int=50
	var r:Rect2i=get_viewport_rect().grow(-m)
	var collision_shape:=CollisionShape2D.new()
	var rectangle_shape:=RectangleShape2D.new()
	add_child(collision_shape)
	collision_shape.shape=rectangle_shape
	rectangle_shape.size=r.size
	position=r.get_center()
	($ColorRect as ColorRect).global_position=r.position
	($ColorRect as ColorRect).size=r.size
	_rect=r
	print_debug("Arena size is ",_rect," Area: ",_rect.get_area()," px²")

## Get the arena rectangle.
func get_rectangle()->Rect2:
	return _rect

## Try to get a random unoccupied position using rejection sampling.
func random_free_point()->Vector2:
	var collidables:Array[Circle]=[]
	for n in get_overlapping_areas():
		var a:Area2D=n as Area2D
		var cs:CollisionShape2D=a.shape_owner_get_owner(0) as CollisionShape2D
		var s:CircleShape2D=cs.shape as CircleShape2D
		if s:
			var c:=Circle.new(a.global_position,s.radius)
			collidables.append(c)
	for n in get_overlapping_bodies():
		var a:PhysicsBody2D=n as PhysicsBody2D
		var cs:CollisionShape2D=a.shape_owner_get_owner(0) as CollisionShape2D
		var s:CircleShape2D=cs.shape as CircleShape2D
		if s:
			var c:=Circle.new(a.global_position,s.radius)
			collidables.append(c)
	var v:Vector2=Vector2.ZERO
	var ok:bool=true
	var j:int=0
	const ATTEMPS:int=20
	for i in ATTEMPS:
		j=i
		v=random_point()
		ok=true
		for n in collidables:
			if v.distance_to(n.position)<n.radius*2:
				ok=false
				break
		if ok:
			break
	if j==ATTEMPS-1:
		print_debug("Couldn't find spot after %d attemps."%ATTEMPS)
	return v

## Get a random point inside the arena.
func random_point()->Vector2:
	return _rect.position+Vector2(randf()*_rect.size.x,randf()*_rect.size.y)
