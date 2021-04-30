extends Button

func _ready():
	connect("pressed", GameSaver, "save_game", [1])
