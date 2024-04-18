extends Sprite2D

## Sprite script that plays the entrance animation for units.

## Faction affects the direction of entry.
@export_enum("Monsters:-1","Player:1") var faction:int=1

func _ready()->void:
	position.y+=400*faction
	modulate.a=0.05
	var t:=create_tween()
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING).tween_property(self,"position:y",0,0.8)
	t.set_parallel().tween_property(self,"modulate:a",1.0,1.0)
