extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	# animate out of current screen
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	# change scene, if scene gives error, crash the game
	assert(get_tree().change_scene(path) == OK)
	# animate from black into new scene
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
