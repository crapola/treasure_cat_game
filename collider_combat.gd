class_name ColliderCombat
extends Node

## ColliderCombat.
##
## Provides melee combat logic to an Actor.

func _ready()->void:
	var area:Area2D=get_parent() as Area2D
	if not area or not area.owner:
		printerr("No owner!")
	if area:
		area.body_entered.connect(
			func(o:CharacterBody2D)->void:
				ColliderCombat._on_entered(area.owner as Actor,o)
		)
		area.area_entered.connect(
			func(o:Area2D)->void:
				ColliderCombat._on_entered(area.owner as Actor,o)
		)
	queue_free()

static func _on_entered(me:Actor,o:CollisionObject2D)->void:
	var enemy:Actor=o.owner as Actor
	if me and enemy:
		if me.faction!=enemy.faction:
			Actor.combat(me,enemy)
