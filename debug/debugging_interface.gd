extends Control

const GAME_NODE_PATH:String="/root/Main"

func game_is_running()->bool:
	return get_node_or_null(GAME_NODE_PATH)!=null

func _DebugToggle_toggled(button_pressed:bool)->void:
	var actors:=get_tree().get_nodes_in_group("actor") as Array[Node]
	for a:Actor in actors:
		if button_pressed:
			actor_debug_on(a)
		else:
			actor_debug_off(a)

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

func actor_debug_off(a:Actor)->void:
	if a.get_node_or_null("DebugLabel"):
		a.get_node("DebugLabel").free()

func actor_debug_on(a:Actor)->void:
	var l:=Label.new()
	l.position=Vector2(0,32)
	l.text="0"
	l.name="DebugLabel"
	a.add_child(l)
	var t:=Timer.new()
	l.add_child(t)
	t.start(0.1)
	t.timeout.connect(func()->void:
		l.rotation=-a.global_rotation
		l.text=str(a.health)
		if a.velocity_component:
			l.text+="\n"+"v="+str(a.velocity_component.velocity.length())
			l.text+="\n"+"a="+str(a.velocity_component.acceleration.length())
		)

func _Statistics_pressed()->void:
	var s:=find_child("Stats",false,false)
	if s:
		s.free()
	else:
		var csv_browser:Control=preload("res://debug/browse_csv.tscn").instantiate() as Control
		csv_browser.name="Stats"
		add_child(csv_browser)
		csv_browser.position.y=64
