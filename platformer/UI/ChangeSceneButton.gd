extends Button

export(String, FILE) var next_scene_path = ""

func _on_button_up():
	get_tree().paused = false
	var err = get_tree().change_scene(next_scene_path)
	if err != OK:
		print("Error changing scene: " + err)
