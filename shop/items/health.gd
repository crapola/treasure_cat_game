extends ShopItem

func give_to_actor(actor:Actor)->void:
	actor.health+=1
	var particles:=preload("res://particles/heal.tscn").instantiate()
	actor.add_child(particles)
	queue_free()
