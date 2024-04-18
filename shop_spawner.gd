extends Node

## Spawn the shop at regular intervals.

## Arena to spawn in.
@export var arena:Arena
## Shop won't spawn if player doesn't have this amount to spend.
@export var min_gold:int=50
## Time between spawns.
@export var wait_time:float=5.0:
	set(value):
		wait_time=value
		if not _timer:
			return
		_timer.wait_time=wait_time
		print_debug("Shop timer set to ",value)
	get:
		return wait_time

@onready var _timer:Timer=$Timer as Timer

## Player faction, set by main loop.
var player_faction:Faction

func _ready()->void:
	self.wait_time=wait_time
	_timer.timeout.connect(spawn)
	_timer.start()

## Restart timer.
func reset()->void:
	_timer.start()

## Spawn the shop if conditions are met.
func spawn()->void:
	if _get_player_gold()<min_gold or get_node_or_null("Shop")!=null:
		return
	var actor:Node2D=preload("res://shop/shop.tscn").instantiate() as Node2D
	actor.position=arena.random_free_point()
	add_child(actor)

func _get_player_gold()->int:
	return player_faction.gold
