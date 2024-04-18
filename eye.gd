extends Sprite2D

@export var velocity:Velocity

func _process(_delta:float)->void:
	rotation=velocity.velocity.angle()
