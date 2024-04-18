extends Control

@onready var player_gold:Label=$Player
@onready var player_health:PictorialValue=$PlayerHealth/PictorialValue
@onready var monsters_gold:Label=$Monsters

var _start_time:int=Time.get_unix_time_from_system() as int

func _ready()->void:
	_clock_update()

func player_info_update(player:Cat)->void:
	player_health.value=player.health

func faction_update(num:int,faction:Faction)->void:
	var labels:Array[Label]=[player_gold,monsters_gold]
	var label:Label=labels[num]
	label.text=label.name+" "+"$"+str(faction.gold)

func clock_stop()->void:
	($Time/Timer as Timer).stop()

func _clock_update()->void:
	var e:int=(Time.get_unix_time_from_system() as int)-_start_time
	($Time as Label).text="Time "+Time.get_time_string_from_unix_time(e)
