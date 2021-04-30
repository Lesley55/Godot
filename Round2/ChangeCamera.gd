extends Button

var cam = 1

func _ready():
	connect("pressed", self, "_change_camera")

func _change_camera():
#	var c = get_parent().get_parent().get_node("Camera2D3")
#	var c2 = get_parent().get_parent().get_node("Camera2D2")
#	if c2.current:
#		c.current = true
#	else:
#		c2.current = true
	get_parent().get_parent().get_node("Camera2D" + String(cam % 3 + 1)).current = true
	cam += 1
