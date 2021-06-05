extends Button

func _on_button_up():
#	score = 0
	get_tree().paused = false
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("Error reloading scene: " + err)
