class_name ActorStats
extends Node

## Actor stats.
##
## This node is attached to every [Actor] in debug mode.
## It collects and save statistics upon exit.

## Actor instance.
var actor:Actor
## Starting health.
var health:int=0
var spawn_time:int=Time.get_ticks_msec()
## Total gold collected.
var gold_collected:int=0
var speed:float=0
## Static reference to the stats CSV file.
static var actor_stats_csv:CSV=CSV.new("user://actor_stats.csv")

func _init(a:Actor)->void:
	actor=a
	health=a.health
	a.gold_collected.connect(func(value:int)->void:
		gold_collected+=value)

func _exit_tree()->void:
	print_debug("Stats exit")
	actor_stats_csv.write_fields(statistics())

## Statistics dictionary.
func statistics()->Dictionary:
	var lifetime:float=float(Time.get_ticks_msec()-spawn_time)/1000.0
	return {
		"name":actor.name,
		"health":health,
		"lifetime":lifetime,
		"gold":gold_collected
		}
