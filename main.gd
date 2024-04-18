extends Node2D

const Hud:=preload("res://hud.gd")
const ShopSpawner:=preload("res://shop_spawner.gd")

@onready var actors_root:Node=$Actors
@onready var arena_area:Arena=$ArenaArea as Arena
@onready var canvaslayer_ui:CanvasLayer=$CanvasLayerUI as CanvasLayer
@onready var hud:Hud=$CanvasLayerUI/HUD as Hud
@onready var player:Cat=$Actors/CatActor as Cat
@onready var shop_spawner:ShopSpawner=$ShopSpawner as ShopSpawner
@onready var timer:Timer=$Timer as Timer

var autobuy_threshold:int=5000
var factions:Array[Faction]=[Faction.new(),Faction.new()]
var gold_spawned_total:int=0
var start_time:int=Time.get_ticks_msec()

var _next_monster:StringName=&"skull"

func _init()->void:
	print_debug("main.gd::_init")

func _ready()->void:
	print_debug("main.gd::_ready")
	Actor.arena_rect=arena_area.get_rectangle()
	factions[0].updated.connect(hud.faction_update.bind(0,factions[0]))
	factions[1].updated.connect(hud.faction_update.bind(1,factions[1]))
	factions[0].name="Player"
	factions[1].name="Enemies"
	# Update hud
	factions[0].gold=factions[0].gold
	factions[1].gold=factions[1].gold
	# Player.
	player.faction=factions[0]
	player.collide_shop.connect(shop_open)
	player.health_changed.connect(hud.player_info_update.bind(player).unbind(1))
	player.health=player.health#   +10
	player.global_position=get_viewport_rect().get_center()
	player.tree_exiting.connect(end_game.bind("Defeat!"),CONNECT_DEFERRED)

	shop_spawner.player_faction=player.faction

	# Spawn some monsters.
	player.body.shape_owner_set_disabled(0,true)
	for i in 4:
		var n:Actor=preload("res://actors/skull.tscn").instantiate() as Actor
		spawn_unit(n,1)
		# Avoid center where player is. TODO: jank
		var center:=arena_area.get_rectangle().get_center()
		var center_to_n:=n.global_position-center
		if center_to_n.length()<100:
			n.position+=center_to_n.normalized()*100
	player.body.shape_owner_set_disabled(0,false)

	#spawn_unit(preload("res://clever_skull.tscn").instantiate(),1)

	# Perform a game tick right now.
	_on_timer_timeout()

func end_game(message:String)->void:
	print_debug("main.gd::end_game ",message)
	if timer.is_stopped():
		return
	timer.stop()
	hud.clock_stop()
	shop_spawner.free()
	var n:=preload("res://game_over.tscn").instantiate()
	(n.get_node("Message") as Label).text=message
	canvaslayer_ui.add_child(n)
	actors_root.propagate_call("set_physics_process",[false])

func enemy_count()->int:
	var count:int=0
	for a:Actor in $Actors.get_children() as Array[Actor]:
		a=a as Actor
		if a and a.faction==factions[1]:
			count+=1
	return count

## The monster faction AI.
func monster_buy()->void:
	const hp=15
	const monsters:Dictionary={
		&"skull":10*hp,
		&"spider":10*hp,
		&"clever_skull":10*hp+25,
		&"ghost":10*hp+25,
		&"bomb":250
		}
	const actor_path:StringName=&"res://actors/"
	# TODO: Can't have safe line with Dictionaries.
	if factions[1].gold>=monsters[_next_monster]+25:
		if _next_monster==&"bomb":
			var scene:=load(_next_monster+".tscn") as PackedScene
			var n:Node2D=scene.instantiate() as Node2D
			n.position=arena_area.random_free_point()
			actors_root.add_child(n,true) # TODO refactor
		else:
			var scene:=load(actor_path+_next_monster+".tscn") as PackedScene
			var n:Actor=scene.instantiate() as Actor
			spawn_unit(n,1)
			@warning_ignore("unsafe_cast")
			factions[1].gold-=(monsters[_next_monster] as int)
		_next_monster=monsters.keys().pick_random()

func pay_wages()->void:
	var nodes:Array[Node]=get_tree().get_nodes_in_group("actor")
	for n in nodes:
		var a:Actor=n as Actor
		if not a.pay_salary():
			if randf()>0.5:
				a.desert()

func player_autobuy()->void:
	if factions[0].gold>100+autobuy_threshold:
		var n:Actor=preload("res://actors/mouse.tscn").instantiate() as Actor
		n.position=arena_area.random_free_point()
		n.faction=factions[0]
		actors_root.add_child(n)
		factions[0].gold-=100

## Spawn item bought in the shop.
func shop_on_buy(item:ShopItemInfo)->void:
	player.faction.gold-=item.price
	var node:Node2D=item.scene.instantiate() as Node2D
	if node is Actor:
		(node as Actor).faction=factions[0]
	node.position=arena_area.random_free_point()
	actors_root.add_child(node,true)

func shop_open(shop:Shop)->void:
	const ShopInterface:=preload("res://shop/interface.gd")
	var shop_ui:ShopInterface=preload("res://shop/interface.tscn").instantiate() as ShopInterface
	shop_ui.gold=player.faction.gold
	shop_ui.buy.connect(shop_on_buy)
	canvaslayer_ui.add_child(shop_ui)
	shop.close()
	shop_spawner.reset()

## Soawn a gold bag somewhere.
func spawn_bag()->void:
	var n:GoldBag=preload("res://items/gold_bag.tscn").instantiate() as GoldBag
	n.position=arena_area.random_free_point()
	gold_spawned_total+=n.gold
	actors_root.add_child(n,true)

func spawn_unit(actor:Actor,faction:int)->void:
	actor.position=arena_area.random_free_point()
	actor.faction=factions[faction]
	actors_root.add_child(actor,true)

func victory_check()->void:
	if enemy_count()==0:
		end_game("Victory!")

func _on_timer_timeout()->void:
	pay_wages()
	spawn_bag()
	monster_buy()
	player_autobuy()
	victory_check()
