class_name Velocity
extends Node

## Velocity component.

## Acceleration px/s².
@export var acceleration:Vector2=Vector2.ZERO
## Speed multiplier.
@export var speed_scale:float=1.0
## Velocity px/s.
@export var velocity:Vector2=Vector2.ZERO

## Resistance.
const R:float=100

## Global position of the owning Node2D.
var global_position:Vector2:
	get:
		return (owner as Node2D).global_position

func _ready()->void:
	print_debug("Velocity owner: ",owner)
	process_physics_priority=owner.process_physics_priority-1

func _physics_process(delta:float)->void:
	velocity+=acceleration*delta
	acceleration=acceleration.move_toward(Vector2.ZERO,delta*R) # reduce R per second
	# integral is A²/(2*R*delta)
	# best approx to discrete sum is A²/(2*R*delta) + A/2

## Accelerate to desired speed in given time.
func accelerate(final_speed:Vector2,time:float=1.0)->void:
	acceleration=(final_speed-velocity)/(time*time)*4

## Counter current velocity to an halt.
func decelerate()->void:
	var pfps:float=Engine.physics_ticks_per_second
	var l:float=velocity.length()
	# Formula is result of equation
	# V=∫ A dt (left Riemann sum of acceleration over time).
	var acc:float=(-0.5+sqrt(0.25+2.0*l/R*pfps*pfps))*R/pfps
	acceleration=-velocity.normalized()*acc

## Set velocity towards a target.
func move_towards(target:Vector2,speed:float)->void:
	velocity=(target-(owner as Node2D).global_position).normalized()*speed

## Randomize velocity.
func random(magnitude:float)->void:
	velocity=Vector2.RIGHT.rotated(TAU*randf())*magnitude

## Reset velocity and acceleration.
func zero()->void:
	velocity=Vector2.ZERO
	acceleration=Vector2.ZERO
