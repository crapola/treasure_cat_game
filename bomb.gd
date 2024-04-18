extends Area2D

@export var ticks:int=4

@onready var blast_sprite:=$BlastVisual as Node2D
@onready var boom_sound:=$Boom as AudioStreamPlayer2D
@onready var label:=$FloatingText as Label
@onready var sprite:=$BombSprite as Sprite2D
@onready var tick_sound:=$Tick as AudioStreamPlayer2D

var _blast_radius:float
var _ticks:int=ticks
var _tween:Tween

func _ready()->void:
	label.self_modulate.a=0.0
	blast_sprite.visible=false
	blast_sprite.rotation_degrees=randf_range(0,360)
	_blast_radius=(($BlastCollisionShape as CollisionShape2D).shape as CircleShape2D).radius

func _process(_delta:float)->void:
	# Intensify shaking as time decreases.
	var i:float=ticks/float(_ticks)
	sprite.position.x=2+i*randf_range(-0.5,0.5)
	sprite.position.y=-3+i*randf_range(-0.5,0.5)

func _Timer_timeout()->void:
	_ticks-=1
	if _ticks>0:
		_tick()
		tick_sound.play()
		label.text=str(_ticks)
	else:
		set_process(false)
		_explode()

func _blast_animation()->void:
	blast_sprite.visible=true
	sprite.visible=false
	_tween=create_tween()
	blast_sprite.scale=Vector2.ZERO
	const t:float=0.25
	_tween.set_parallel()
	_tween.tween_property(blast_sprite,"scale",Vector2.ONE*_blast_radius*2.0,t)
	var c:Color=Color.RED
	c.a=0.1
	_tween.tween_property(blast_sprite,"modulate",c,t)
	_tween.finished.connect(queue_free)

func _explode()->void:
	# Damage actors caught in blast radius.
	var areas:Array=get_overlapping_areas()+get_overlapping_bodies() as Array
	for a:Node2D in areas:
		var actor:Actor=a.owner as Actor
		if actor:
			var direction:Vector2=global_position.direction_to(actor.global_position)
			var distance:=global_position.distance_to(actor.global_position)
			distance=min(distance,_blast_radius)
			var force:float=_blast_radius-distance
			var damage:int=int(1+10*force/_blast_radius)
			print_debug("Bomb damages %s with force=%d, damage=%d."%[actor.name,force,damage])
			actor.damage(damage)
			actor.push(direction*force*2.0)
	_blast_animation()
	# Boom sound.
	boom_sound.reparent(get_parent())
	boom_sound.finished.connect(boom_sound.queue_free)
	boom_sound.play()

func _tick()->void:
	_tween=create_tween()
	sprite.scale=Vector2.ONE*(1.1+((ticks-_ticks)/10.0))
	_tween.set_parallel()
	_tween.tween_property(sprite,"scale",Vector2.ONE,0.5)
	#
	label.scale=Vector2.ONE
	_tween.tween_property(label,"scale",Vector2.ONE*2,0.5)
	label.position.y=-14
	label.self_modulate.a=1.0
	_tween.tween_property(label,"position:y",-64,0.5)
	_tween.tween_property(label,"self_modulate:a",0,0.5)
