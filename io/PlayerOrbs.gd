extends Node2D

var time_start = 0
var time_stop = 0

func _ready():
	time_start = OS.get_unix_time() # get start time

func _process(delta):
	if get_child_count() < 1:
		time_stop = OS.get_unix_time() # get end time
		var elapsed_time = time_stop - time_start # calculate elapsed time
		
		PlayerData.die(elapsed_time)
		queue_free()
