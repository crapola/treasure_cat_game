class_name Chase
extends Behaviour

## Chasing behaviour.

## Speed of the chasing [Actor].
@export var speed:float=32
## Target to follow.
@export var target:Node2D:
	set(value):
		if not is_inside_tree():
			return
		target=value
		if target:
			target.tree_exited.connect(func()->void:
				target=null
				)
			start()
		else:
			stop()
	get:
		return target

## Update chaser's velocity.
func do()->void:
	_actor.velocity_component.move_towards(target.global_position,speed)

## Assign [param other] as the target.
func on_detected(other:Node2D)->void:
	if not target:
		target=other
