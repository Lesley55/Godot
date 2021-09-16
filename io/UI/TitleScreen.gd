extends Control

func _on_ColorPicker_color_changed(color):
	PlayerData.color = color

func _on_LineEdit_text_changed(new_text):
	PlayerData.playerName = new_text
