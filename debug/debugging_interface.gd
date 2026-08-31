extends Control

const GAME_NODE_PATH:String="/root/Main"

@onready var debug_toggle:CheckBox=$HFlowContainer/DebugToggle

func game_is_running()->bool:
	return get_node_or_null(GAME_NODE_PATH)!=null

func on_actor_added(actor:Actor)->void:
	var ai:=preload("res://debug/actor_info.tscn").instantiate()
	actor.add_child(ai)
	ai.visible=debug_toggle.button_pressed

func _DebugToggle_toggled(button_pressed:bool)->void:
	for n in get_tree().get_nodes_in_group(&"debug"):
		n.visible=button_pressed

func _input(event:InputEvent)->void:
	var ik:InputEventKey=event as InputEventKey
	if ik and ik.pressed and game_is_running():
		const Game=preload("res://main.gd")
		var game:=get_node(GAME_NODE_PATH) as Game
		var player:Cat=get_node(GAME_NODE_PATH+"/Actors/CatActor") as Cat
		match ik.as_text_key_label():
			"F1":
				print_debug("Show/hide debug UI.")
				visible=!visible
			"F2":
				var image:=get_viewport().get_texture().get_image()
				var i:int=0
				var path:String="user://screenshot%d.png"%i
				while FileAccess.file_exists(path) and i<100:
					i+=1
					path="user://screenshot%d.png"%i
				image.save_png(path)
				print_debug("Screenshot saved to %s"%path)
			"G":
				print_debug("Cheat gold.")
				player.give_gold(1000)
			"S":
				print_debug("Cheat shop.")
				var s:=preload("res://shop/shop.tscn").instantiate() as Shop
				add_child(s)
				game.shop_open(s)
			"B":
				var mouse_pos:=get_global_mouse_position()
				print_debug("Cheat drop bomb at %s."%mouse_pos)
				var bomb:=preload("res://bomb.tscn").instantiate() as Area2D
				bomb.global_position=mouse_pos
				game.add_child(bomb)
			"M":
				print_debug("Cheat give monsters gold.")
				game.factions[1].gold=1000

func _Statistics_pressed()->void:
	var s:=find_child("Stats",false,false)
	if s:
		s.free()
	else:
		var csv_browser:Control=preload("res://debug/browse_csv.tscn").instantiate() as Control
		csv_browser.name="Stats"
		add_child(csv_browser)
		csv_browser.position.y=64
