extends Control


@onready var player=$Player
@onready var enemy: Sprite2D = $Enemy
@onready var result: Sprite2D = $Result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result.position=_avoid_player(enemy.position)

func _avoid_player(pos:Vector2)->Vector2:
	prints(pos,player.position,pos+(player.position-pos)/2.0)
	var pp=player.position
	var v=player.position-pos
	var n=player.position.direction_to(pos)
	var d=512
	var f=1-pp.distance_to(pos)/d
	return pos+player.position.direction_to(pos)*(1-pp.distance_to(pos)/512)*256
	#return pos+n*f*256

func _input(e)->void:
	enemy.position=get_local_mouse_position()
	result.position=_avoid_player(enemy.position)
