class_name Feeding
extends Node

## Make owning Actor heal from kills.

var _actor:Actor
var _initial_health:int

func _ready()->void:
	_actor=owner as Actor
	_initial_health=_actor.health
	_actor.killed.connect(func(_other:Actor)->void:
		# Double current health, capped at starting value.
		_actor.health=mini(_initial_health,_actor.health*2)
		)
