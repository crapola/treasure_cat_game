extends ShopItem

func give_to_actor(actor:Actor)->void:
	if actor.buff_give(SpeedBuff):
		queue_free()
