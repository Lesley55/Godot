extends Node

const END_VALUE = 1 # normal speed

var is_active = false
var start_time
var duration_ms
var start_value

func start(duration = 0.4, strenght = 0.9):
	start_time = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strenght
	Engine.time_scale = start_value
	is_active = true

func _process(delta):
	if is_active:
		var current_time = OS.get_ticks_msec() - start_time
		var value = _circle_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
		Engine.time_scale = value

func _circle_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1) + b
