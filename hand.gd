class_name Hand
extends Node2D

## Invisible limb to which a [Node2D] is attached.

@onready var _hand:Marker2D=$Hand as Marker2D

func _physics_process(delta:float)->void:
	var a:Actor=owner as Actor
	if a.velocity_component:
		const rot_speed:float=TAU*4.0
		rotation=rotate_toward(rotation,a.velocity_component.velocity.angle(),delta*rot_speed)

## Check if there's an item in hand.
func has_item()->bool:
	assert(_hand)
	return _hand.get_child_count()>0

## Give item.
func give_item(node:Node2D)->void:
	node.position=Vector2.ZERO
	if node.is_inside_tree():
		node.reparent(_hand,false) # Keep global transform.
	else:
		_hand.add_child(node)
