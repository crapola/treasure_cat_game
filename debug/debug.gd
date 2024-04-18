extends Node

func _init()->void:
	print_debug()

func _ready()->void:
	print_debug()

	## Create debug interface.
	var ui:=preload("res://debug/debugging_interface.tscn").instantiate()
	get_tree().root.add_child.call_deferred(ui)

	## Statistics injection.
	get_tree().node_added.connect(_on_node_added_to_tree)

func _exit_tree()->void:
	print_debug()
	const MainScript:=preload("res://main.gd")
	var main:=get_node("/root/Main") as MainScript
	if main:
		_game_stats(main.start_time,main.gold_spawned_total,main.factions)
		ActorStats.actor_stats_csv.save()
	print("Debug:EOF")

func _on_node_added_to_tree(n:Node)->void:
	if n is Actor:
		print_debug("Debug: Attaching debug stats to actor %s."%n.name)
		n.add_child(ActorStats.new(n as Actor))

func _game_stats(start_time:int,gold_spawned_total:int,factions:Array)->void:
	print("Game statistics:")
	var elapsed:float=(Time.get_ticks_msec()-start_time)/1000.0
	print("Time elapsed: "+str(elapsed)+" seconds.")
	print("Gold spawned: "+str(gold_spawned_total)+" gold "+str(gold_spawned_total/elapsed)+" gold/second")
	for f:Faction in factions:
		print("Faction "+f.name+" accumulated "+str(f.gold_total_collected)+" gold "+str(f.gold_total_collected/elapsed)+" gold/second" )
