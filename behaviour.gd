class_name Behaviour
extends Node

## Behaviour
##
## Perform an action on its [Actor] owner at regular intervals using an
## internal [Timer].

## Emitted when [method start] is called.
signal started
## Emitted when [method stop] is called.
signal stopped

## Auto-start the timer.
@export var autostart:bool=false
## Timer wait time.
@export var period:float=1.0

## Owning Actor on which to perform actions.
var _actor:Actor
## Internal timer.
var _timer:Timer

func _ready()->void:
	_actor=owner as Actor
	assert(_actor,"Owner isn't an Actor.")
	_timer=Timer.new()
	_timer.autostart=autostart
	_timer.timeout.connect(do)
	_timer.process_callback=Timer.TIMER_PROCESS_PHYSICS
	_timer.wait_time=period
	add_child(_timer)

## Virtual function.
func do()->void:
	pass

## Start the behaviour. [method do] will be called by the internal timer.
func start()->void:
	_timer.start()
	started.emit()

## Stop the behaviour.
func stop()->void:
	_timer.stop()
	stopped.emit()
