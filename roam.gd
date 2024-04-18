class_name Roam
extends Behaviour

## Roaming behaviour.

func _ready()->void:
	super._ready()
	assert(_actor and _actor.velocity_component)

func do()->void:
	var velocity:=_actor.velocity_component
	if randi()%4==0:
		velocity.random(8)
		return
	velocity.random(64)
