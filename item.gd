class_name Item
extends Area2D

## Abstract base class for item pickups.
##
## [Area2D] that interacts with [Actor]s.
## Individual item scripts subclass this and implement [method give_to_actor].

func _init()->void:
	area_entered.connect(_on_area_or_body_entered,CONNECT_DEFERRED)
	body_entered.connect(_on_area_or_body_entered,CONNECT_DEFERRED)
	collision_layer=8
	collision_mask=1+2

func _on_area_or_body_entered(other:CollisionObject2D)->void:
	var actor:Actor=other.owner as Actor
	if actor:
		give_to_actor(actor)

## Virtual method called on the colliding Actor.
func give_to_actor(_actor:Actor)->void:
	pass
