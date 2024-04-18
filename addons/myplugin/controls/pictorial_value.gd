@tool
# If we set tool, the texture created from atlas will be stored in .tscn.
class_name PictorialValue
extends Control

## Pictorial Value
##
## Represent a positive integer with a repeated picture.[br]
## The control size is automatically determined.
## To make it appear larger or smaller, modify the [member image_scale]
## property.

## Overflow threshold.
## When [member value] > [member max_value], the representation switches to a
## single picture and a number.
@export_range(1,1000) var max_value:int=10

## Texture to display.
@export var texture:Texture2D:
	set(t):
		texture=t
		_texture_rect.texture=texture
		_texture_rect.size=texture.get_size()
		size=texture.get_size()

## Relative scaling of the picture.
@export var image_scale:float=1.0:
	set(s):
		image_scale=s
		_update_texture_rect()

## Number of items.
@export_range(0,2,1,"or_greater") var value:int=1:
	get:
		return value
	set(v):
		value=v
		if not _texture_rect or not texture:
			print_debug("Set value but element not ready yet.")
			return
		_overflow_label.text="x"+str(value)
		_update_texture_rect(v)

var _overflow_label:Label=Label.new()
var _texture_rect:TextureRect

func _init()->void:
	resized.connect(_on_resized)
	_texture_rect=TextureRect.new()
	_texture_rect.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode=TextureRect.STRETCH_TILE
	_texture_rect.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
	add_child(_texture_rect)

	_overflow_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	_overflow_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	add_child(_overflow_label)

func _ready()->void:
	if not Engine.is_editor_hint():
		_convert_atlas()
	_update_texture_rect()

func _convert_atlas()->void:
	# AtlasTextures aren't tileable, so we create a single ImageTexture
	# from the region on the fly.
	if texture is AtlasTexture:
		texture=_single_texture_from_atlas_region(texture as AtlasTexture)
		print_debug("Created texture from atlas: %s."%texture)

func _on_resized()->void:
	_update_texture_rect()

func _single_texture_from_atlas_region(atlas:AtlasTexture)->Texture2D:
	assert(atlas,"Null parameter")
	return ImageTexture.create_from_image(atlas.atlas.get_image().get_region(atlas.region))

func _update_texture_rect(count:int=value)->void:
	if not texture:return
	count=maxi(0,count)
	if count>max_value:
		count=1
		_overflow_label.visible=true
	else:
		_overflow_label.visible=false
	_texture_rect.size.x=texture.get_size().x*count
	_texture_rect.scale=Vector2.ONE*image_scale
	size=_texture_rect.size*_texture_rect.scale
	# Toggling visibility forces Godot to refresh control positions.
	# We need it to recenter the label vertically.
	visible=false
	visible=true
	_overflow_label.position.x=size.x
