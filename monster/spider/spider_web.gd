class_name SpiderWeb
extends Area2D

## Spider web.

## An enemy entered the web.
signal prey_entered(prey)
## An enemy exited the web.
signal prey_exited(prey)
## Preys inside the web are slown by this factor.
@export var slow_factor:float=0.25
## Spider that owns this web.
@export var spider:Actor

@onready var _circle_shape:CircleShape2D=($CollisionShape2D as CollisionShape2D).shape as CircleShape2D

var _prey:Actor

func _ready()->void:
	assert(spider)
	spider.tree_exited.connect(queue_free)

## Get the last enemy that entered the web.
func prey()->Actor:
	return _prey

## Get web radius.
func radius()->float:
	return _circle_shape.radius*scale.x

func _modify_other_velocity(area:Area2D,factor:float)->void:
	var actor:Actor=area.owner as Actor
	assert(area.collision_layer==1,"Web wants to slow non-Player.")
	if actor:
		var vc:=actor.velocity_component
		if vc:
			vc.speed_scale*=factor

func _on_area_entered(area:Area2D)->void:
	_modify_other_velocity(area,slow_factor)
	_prey=area.owner as Actor
	prey_entered.emit(area.owner as Actor)

func _on_area_exited(area:Area2D)->void:
	_modify_other_velocity(area,1.0/slow_factor)
	_prey=null
	prey_exited.emit(area.owner as Actor)
