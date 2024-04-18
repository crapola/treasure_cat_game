extends Control

## Shop interface script.

signal buy(item:ShopItemInfo)

const SelectionRectangle:=preload("res://shop/selection_rectangle.gd")

@onready var description:=%Description as Label
@onready var items_root:=%ItemsContainer as HFlowContainer
@onready var nothing:=%Nothing as Label
@onready var selection_rectangle:=%SelectionRectangle as SelectionRectangle
@onready var tooltip:=%ToolTip as Label

var gold:int=0

func _ready()->void:
	get_tree().paused=true
	var num_items:=init_items()
	if num_items==0:
		nothing.visible=true

func add_item_button(shopitem:ShopItemInfo)->void:
	var button:ButtonItem=ButtonItem.new()
	button.set_item(shopitem)
	items_root.add_child(button)
	button.pressed.connect(_on_buy_add_item.bind(button))
	button.mouse_entered.connect(_on_item_hover.bind(button))
	button.name=shopitem.resource_name
	button.mouse_exited.connect(_tooltip_clear)

func init_items()->int:
	var resources:Array[ShopItemInfo]=load_item_resources()
	const numitems:int=20
	var g:int=gold
	var count:int=0
	for i in numitems:
		var item:ShopItemInfo=(resources.pick_random() as ShopItemInfo)
		if item.price<=g:
			add_item_button(item)
			g-=item.price
			count+=1
		else:
			break
		if count>4 and randi()%4==0:
			break
	return count

func load_item_resources()->Array[ShopItemInfo]:
	var available_items:Array[ShopItemInfo]=[]
	const itemdir:=&"res://shop/item_info/"
	var files:=DirAccess.get_files_at(itemdir)
	for f in files:
		# Stupid hack for HTML5 version.
		if ".remap" in f:
			f=f.replace(".remap","")
		available_items.append(load(itemdir+f))
	return available_items

func cancel()->void:
	get_tree().paused=false
	queue_free()

func _on_buy_add_item(button_item:ButtonItem)->void:
	buy.emit(button_item.item)
	button_item.queue_free()
	selection_rectangle.collapse()
	tooltip.text="Bought "+str(button_item.item.resource_name)+"."
	description.text=""

func _on_item_hover(button_item:ButtonItem)->void:
	tooltip.text=button_item.item.resource_name+" $"+str(button_item.item.price)
	description.text=button_item.item.description
	selection_rectangle.highlight(button_item)

func _tooltip_clear()->void:
	tooltip.text=""
	description.text=""
