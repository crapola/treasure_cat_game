class_name Arena
extends Area2D

## Game arena.
##
## Rectangular game arena.

class Circle:
	var position:Vector2
	var radius:float
	func _init(p:Vector2,r:float)->void:
		position=p
		radius=r

func _ready()->void:
	# Make Area2D's rectangle shape match the ColorRect.
	var r:Rect2i=($ColorRect as ColorRect).get_rect() as Rect2i
	var collision_shape:CollisionShape2D=$CollisionShape2D as CollisionShape2D
	var rectangle_shape:RectangleShape2D=collision_shape.shape as RectangleShape2D
	rectangle_shape.size=r.size

## Get the arena rectangle.
func get_rectangle()->Rect2:
	return ($ColorRect as ColorRect).get_rect()

## Try to get a random unoccupied position using rejection sampling.
func random_free_point(radius:float=0.0)->Vector2:
	var collidables:Array[Circle]=[]
	for n in get_overlapping_areas():
		var a:Area2D=n as Area2D
		var cs:Shape2D=a.shape_owner_get_shape(0,0) as Shape2D
		var s:CircleShape2D=cs as CircleShape2D
		if s:
			var c:=Circle.new(a.global_position,s.radius)
			collidables.append(c)
	for n in get_overlapping_bodies():
		var a:PhysicsBody2D=n as PhysicsBody2D
		var cs:Shape2D=a.shape_owner_get_shape(0,0) as Shape2D
		var s:CircleShape2D=cs as CircleShape2D
		if s:
			var c:=Circle.new(a.global_position,s.radius)
			collidables.append(c)
	#print_debug("%d collidables."%collidables.size())
	var v:Vector2=Vector2.ZERO
	var ok:bool=true
	var j:int=0
	const ATTEMPS:int=20
	for i in ATTEMPS:
		j=i
		v=random_point()
		ok=true
		for n in collidables:
			if v.distance_to(n.position)<(n.radius+radius):
				ok=false
				break
		if ok:
			break
	if j==ATTEMPS-1:
		print_debug("Couldn't find spot after %d attemps."%ATTEMPS)
		push_warning("Couldn't find spot after %d attemps."%ATTEMPS)
	return v

## Get a random point inside the arena.
func random_point()->Vector2:
	var _rect:Rect2=get_rectangle()
	return _rect.position+Vector2(randf()*_rect.size.x,randf()*_rect.size.y)
