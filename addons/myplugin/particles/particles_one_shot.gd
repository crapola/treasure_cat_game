class_name GPUParticles2DOneShot
extends GPUParticles2D

## One-shot particle.
##
## A GPUParticles2D that self-deletes after its lifetime expired.

func _init()->void:
	one_shot=true

func _ready()->void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
