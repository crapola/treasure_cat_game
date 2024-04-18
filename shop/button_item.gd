class_name ButtonItem
extends TextureButton

## [TextureButton] representing an item in the shop interface.

## The [ShopItemInfo] describing the item.
var item:ShopItemInfo

func _init()->void:
	texture_normal=preload("res://icon.svg")

## Set the item and texture.
func set_item(sitem:ShopItemInfo)->void:
	item=sitem
	texture_normal=item.texture


