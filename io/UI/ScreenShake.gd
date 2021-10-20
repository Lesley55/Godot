extends Node

var amplitude = 0
var priority = 0

onready var camera = get_parent()
onready var duration = $Duration
onready var frequency = $Frequency
onready var shakeTween = $ShakeTween

# frequency = shakes per second
# amplitude = amount of pixels the screen can shake to both sides
func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		self.amplitude = amplitude
		self.priority = priority
		
		self.duration.wait_time = duration
		self.frequency.wait_time = 1 / float(frequency)
		self.duration.start()
		self.frequency.start()
		
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	shakeTween.interpolate_property(camera, "offset", camera.offset, rand, frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	shakeTween.start()

func _reset():
	shakeTween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	shakeTween.start()
	
	priority = 0

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	frequency.stop()
