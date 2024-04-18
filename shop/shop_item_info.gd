class_name ShopItemInfo
extends Resource

## Resource describing a [ShopItem].

## Description.
@export_multiline var description:String
## Price in gold.
@export var price:int
## [ShopItem] scene to be spawned.
@export var scene:PackedScene
## Icon shown in the shop.
@export var texture:Texture2D=preload("res://icon.svg")
