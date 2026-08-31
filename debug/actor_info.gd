extends Control

@onready var _actor:Actor=get_parent()

func _ready()->void:
	assert(get_parent() is Actor)
	print_debug(self," attached to ",_actor)

func _on_Timer_timeout()->void:
	%Name.text=_actor.name
	%Health.text=str(_actor.health)
	%Position.text=str(_actor.position)
	rotation=0
