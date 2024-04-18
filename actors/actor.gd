class_name Actor
extends Node2D

## Actor.
##
## Base class for game objects.

## Actor collected gold for its faction.
signal gold_collected(value:int)
## Health changed.
signal health_changed(value:int)
## Killed by other.
signal killed(other:Actor)
## Allow buffs.
@export var buffs:bool=false
## Forbid exiting the arena.
@export var clamp_position:bool=true
## This actor's hand.
@export var hand:Hand
## Health.
@export var health:int=10:
	set(value):
		health=value
		health_changed.emit(value)
	get:
		return health
## Sound played upon damage.
@export var hit_sound:AudioStreamPlayer2D
@export var velocity_component:Velocity
## This unit's salary, to be deduced from its faction's treasury every game tick.
@export var wage:int=1
## The main collision body.
var body:CollisionObject2D
## The faction.
var faction:Faction
## Main sprite.
var sprite:Sprite2D
## Static reference to the game arena rectangle.
static var arena_rect:Rect2i

# Keep Tween so we can stop it.
var _tweener:Tween

func _init()->void:
	add_to_group("actor")

func _ready()->void:
	print_debug("Actor::_ready\n\tname=",name," \n\tsprite=",sprite)
	set_process((body as CharacterBody2D)!=null)
	set_physics_process(true)
	if is_processing():
		print_debug("\t",name," uses transform trick.")

func _notification(what:int)->void:
	if what==NOTIFICATION_SCENE_INSTANTIATED:
		_scene_init()

func _physics_process(delta:float)->void:
	if clamp_position:
		var r:Rect2i=arena_rect
		global_position=global_position.clamp(r.position,r.end)
	_apply_velocity(delta)

func _process(_delta:float)->void:
	# _process is enabled when 'body' is CharacterBody2D.
	# Base Node2D steals the CharacterBody2D's transform every frame.
	global_transform=body.global_transform
	body.transform=Transform2D.IDENTITY

#-------------------------------------------------------------------------------
## Give a buff.
func buff_give(buff:GDScript)->bool:
	if buffs:
		var buff_node:Node=buff.new() as Node # TODO
		add_child(buff_node)
	return buffs

## Apply damage to health, play animation and hit sound.
func damage(value:int)->void:
	health-=value
	if health<=0:
		print_debug(self.name," defeated.")
		var smoke:=preload("res://particles/smoke_puff.tscn").instantiate() as Node2D
		smoke.transform=transform
		smoke.scale*=0.75
		add_sibling(smoke)
		queue_free()
		return
	# Animation.
	rotate(randf()-0.5)
	sprite.modulate=Color.RED
	if _tweener:
		_tweener.stop()
	_tweener=create_tween()
	_tweener.set_parallel()
	_tweener.tween_property(self,"rotation",0,0.25)
	_tweener.tween_property(sprite,"modulate",Color.WHITE,0.25)
	# Sound.
	if hit_sound:
		hit_sound.play()

## Desertion.
func desert()->void:
	print_debug(self.name," has deserted.")
	queue_free()

## Collect gold for the faction. If it has no faction, return false.
func give_gold(value:int)->bool:
	if faction:
		faction.gold+=value
		gold_collected.emit(value)
		return true
	else:
		return false

## Check wether the hand is wielding something.
func hand_free()->bool:
	return hand and not hand.has_item()

## Try to pay salary.
## Return false if the faction couldn't pay, true if there's no faction or the
## unit is free.
func pay_salary()->bool:
	if wage<=0 or not faction:
		return true
	if faction and faction.gold>=wage:
		faction.gold-=wage
		return true
	return false

## Push actor and decelerate.
func push(velocity:Vector2)->void:
	if velocity_component:
		velocity_component.velocity+=velocity
		velocity_component.decelerate()

## Perform melee combat between two actors. Both are damaged and pushed away.
static func combat(a:Actor,b:Actor)->void:
	a.damage(1)
	b.damage(1)
	bump(a,b,180)
	if a.health==0:
		b.killed.emit(a)
	if b.health==0:
		a.killed.emit(b)

## Push two Actors away from each other.
static func bump(a:Actor,b:Actor,force:float=1.0)->void:
	var vca:=a.velocity_component
	var vcb:=b.velocity_component
	var ab:Vector2=a.global_position.direction_to(b.global_position).normalized()*force
	if vca:
		_bump_vel(vca,ab)
	if vcb:
		_bump_vel(vcb,-ab)

static func _bump_vel(v:Velocity,v_to_other:Vector2)->void:
	v.velocity-=v_to_other
	v.decelerate()

func _apply_velocity(delta:float)->void:
	if not velocity_component:
		return
	if body is CharacterBody2D:
		var cbody:=body as CharacterBody2D
		cbody.velocity=velocity_component.velocity*velocity_component.speed_scale
		cbody.move_and_slide()
	else:
		position+=velocity_component.velocity*delta*velocity_component.speed_scale

func _scene_init()->void:
	sprite=find_child("Sprite2D") as Sprite2D
	var c:=get_child(0)
	if c is CollisionObject2D:
		body=get_child(0) as CollisionObject2D
