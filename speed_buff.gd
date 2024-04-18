class_name SpeedBuff
extends Node2D

## Temporary speed buff applied to [Actor] parent node.
##
## The buff is applied as soon as the node enters the tree. When time is over,
## this node reverts the buff and self-deletes.

## Speed multiplier.
const MULTIPLIER:float=1.5

func _ready()->void:
	var a:Actor=get_parent() as Actor
	if a and a.velocity_component:
		_enable(a)
		get_tree().create_timer(10,false,true).timeout.connect(queue_free)

func _enable(actor:Actor)->void:
	actor.velocity_component.speed_scale*=MULTIPLIER
	add_child(preload("res://particles/sparkles.tscn").instantiate())

func _disable(actor:Actor)->void:
	actor.velocity_component.speed_scale/=MULTIPLIER

func _exit_tree()->void:
	_disable(get_parent() as Actor)
