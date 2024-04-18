extends Actor

@onready var timer:Timer=$Timer as Timer

var web:SpiderWeb

func _ready()->void:
	super._ready()
	web=preload("res://spider_web.tscn").instantiate() as SpiderWeb
	web.spider=self
	web.global_position=global_position
	web.prey_entered.connect(_on_prey_entered)
	web.prey_exited.connect(_on_prey_exited)
	add_sibling.call_deferred(web)

func _on_prey_entered(_prey:Actor)->void:
	_Timer_timeout()
	timer.start()

func _on_prey_exited(_prey:Actor)->void:
	pass

func _Timer_timeout()->void:
	if web.prey():
		# Chase prey.
		var dist:float=body.global_position.distance_to(web.prey().global_position)
		velocity_component.move_towards(web.prey().global_position,dist/timer.wait_time)
		rotation=velocity_component.velocity.angle()
	else:
		# Spin web.
		velocity_component.zero()
		web.scale+=Vector2.ONE*0.10
		# Roam on web or do nothing.
		if randi()%2==0:
			return
		velocity_component.acceleration=Vector2.ZERO
		var pos:Vector2=Vector2(randf_range(-1,1),randf_range(-1,1))
		pos=Vector2(pos.x*sqrt(1-(pos.y**2)/2), pos.y*sqrt(1-(pos.x**2)/2))
		velocity_component.move_towards(web.global_position+pos*web.radius(),web.radius()/timer.wait_time)
		rotation=velocity_component.velocity.angle()
