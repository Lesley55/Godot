extends Button

export(String, FILE) var next_scene_path = ""

func _on_button_up():
	PlayerData.color = get_parent().get_parent().get_node("ColorPicker").color
	PlayerData.playerName = get_parent().get_parent().get_node("Menu/LineEdit").text
	SceneChanger.change_scene(next_scene_path)
