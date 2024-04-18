extends Actor

const speed:float=55.0

@onready var sensor:=$SkullBody/Sensor as Area2D

var target:Node2D

func _ready()->void:
	super._ready()

func _draw()->void:
	if target:
		draw_line(Vector2.ZERO,target.global_position-global_position,Color.WHITE)

func _process(delta:float)->void:
	super._process(delta)
	#queue_redraw()

func _Timer_on_timeout()->void:
	if target:
		# Move toward current target.
		velocity_component.move_towards(target.global_position,speed)
		# Must reconsider items if we grabbed one on the way...
		if target.owner is Actor and not _want_item(target):
			target=null
	else:
		var g:Item=_find_item()
		if not g:
			g=_find_gold_bag()
		if g:
			target=g
			if not target.tree_exiting.is_connected(_on_target_freed):
				var err:=target.tree_exiting.connect(_on_target_freed)
				assert(err==OK)
			_Timer_on_timeout()
			return
		# If nothing found, random walk.
		velocity_component.random(speed)

func _on_target_freed()->void:
	target=null

func _find_gold_bag()->GoldBag:
	var stuff:Array[Area2D]=sensor.get_overlapping_areas()
	stuff=stuff.filter(func(a:Area2D)->bool:
		return a is GoldBag ) as Array[Area2D]
		#return a.collision_layer==4) as Array[Area2D]
	stuff.sort_custom(func(a:GoldBag,b:GoldBag)->bool:
		return _bag_value(a)>_bag_value(b)
		)
	return stuff[0] as GoldBag if stuff else null

func _find_item()->Item:
	var stuff:Array[Area2D]=sensor.get_overlapping_areas()
	stuff=stuff.filter(func(a:Area2D):
		return a is Item and _want_item(a as ShopItem) ) as Array[Area2D]
	return stuff[0] as Item if stuff else null

func _bag_value(bag:GoldBag)->float:
	var dist:float=global_position.distance_squared_to(bag.global_position)
	return bag.gold/dist

func _want_item(item:ShopItem)->bool:
	if item:
		## Already have an item in hand.
		if item.shop_item==preload("res://shop/item_info/dagger.tres") and not hand_free():
			return false
	return true
