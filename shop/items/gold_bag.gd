class_name GoldBag
extends Item

## Gold bag of random size.

## Smallest possible amount of gold.
const MIN:int=5
## Highest possible amount of gold.
const MAX:int=35
## Average.
@warning_ignore("integer_division")
const AVG:int=(MIN+MAX)/2
## Gold amount.
var gold:int

@onready var _animation:AnimationPlayer=$AnimationPlayer as AnimationPlayer
@onready var _sound:AudioStreamPlayer2D=$AudioStreamPlayer2D as AudioStreamPlayer2D

func _ready()->void:
	gold=MIN+randi()%MAX
	# Appear animation.
	scale=Vector2.ZERO
	var s:Vector2=Vector2.ONE*(0.5+gold/20.0)
	create_tween().tween_property(self,"scale",s,1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

## Give gold to that actor and delete the bag.
func give_to_actor(actor:Actor)->void:
	if gold>0 and actor.give_gold(gold):
		print_debug("%s (%d gold) taken by %s"%[name,gold,actor.name])
		_consume()

func _consume()->void:
	# 5 to 35, avg 20
	_sound.pitch_scale=1.5-gold/(AVG*2.0)
	_sound.play()
	gold=0 # Avoid concurrent double-dipping.
	_animation.play("picked up") # Will queue_free.
