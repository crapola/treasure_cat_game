extends Control

## Randomize bricks appearance.

func _ready()->void:
	var bricks:Array[TextureRect]
	bricks.assign(get_children() as Array[TextureRect])
	for _i in 1+randi()%4:
		var b:TextureRect=bricks.pop_back() as TextureRect
		b.free()
	self.modulate.a=randf()
