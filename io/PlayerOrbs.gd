extends Node2D

var start_time = 0
var current_time = 0
var elapsed_time = 0

func _ready():
	start_time = OS.get_unix_time() # get start time

func _process(_delta):
	current_time = OS.get_unix_time()
	elapsed_time = current_time - start_time # calculate elapsed time
	PlayerData.set_time(elapsed_time)
	
	if get_child_count() < 1:
		PlayerData.die()
		queue_free()
