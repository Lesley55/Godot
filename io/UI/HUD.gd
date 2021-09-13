extends Control

onready var score = $Score
onready var overlay = $Overlay

func _ready():
	overlay.visible = false
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()

func _on_PlayerData_player_died():
	yield(get_tree().create_timer(1), "timeout")
	overlay.visible = true
	PlayerData.reset() # needs to go somewhere else

func update_interface():
	score.text = "Score: %s" % PlayerData.score
