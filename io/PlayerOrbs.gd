extends Node2D

func _process(delta):
	if get_child_count() < 1:
		PlayerData.die()
