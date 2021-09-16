extends Button

func _on_button_up():
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("Error reloading scene: " + err)
