extends Button

func _ready():
	connect("pressed", GameSaver, "load_game", [1])
