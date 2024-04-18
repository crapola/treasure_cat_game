class_name Shop
extends Node2D

## The shop object.

func _ready()->void:
	scale=Vector2.ZERO
	create_tween().tween_property(self,"scale",Vector2.ONE,1.0)

## Remove shop from the arena.
func close()->void:
	$Area2D.free()
	create_tween().tween_property(self,"scale",Vector2.ZERO,1.0).set_trans(Tween.TRANS_BACK)
	await get_tree().create_timer(1,false,true).timeout
	queue_free()
