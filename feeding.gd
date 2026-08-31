class_name Feeding
extends Node

## Make owning Actor heal from kills.

var _actor:Actor
var _initial_health:int

func _ready()->void:
	_actor=owner as Actor
	_initial_health=_actor.health
	_actor.killed.connect(func(_other:Actor)->void:
		# Bad coding, but acceptable as long as the dagger is the only weapon.
		if _other.scene_file_path!="res://actors/dagger_weapon.tscn":
			var h:int=maxi(1,int(_initial_health/4.0))
			_actor.health=mini(_initial_health,_actor.health+h)
		)
