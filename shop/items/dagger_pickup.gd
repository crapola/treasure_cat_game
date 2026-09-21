extends ShopItem

func give_to_actor(actor:Actor)->void:
	if actor.hand_free():
		var weapon:Actor=preload("res://actors/dagger_weapon.tscn").instantiate()
		weapon.faction=actor.faction
		actor.hand.give_item(weapon)
		actor.item_collected.emit(weapon)
		queue_free()
