extends Control

signal screen_shake()

onready var score = $Score
onready var overlay = $Overlay
onready var leaderboard = $Overlay/Leaderboard

func _ready():
	overlay.visible = false
	GameSaver.load_game(1)
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()

func _on_PlayerData_player_died():
	emit_signal("screen_shake")
	GameSaver.save_game(1)
	leaderboard.update_leaderboard()
	yield(get_tree().create_timer(1), "timeout")
	overlay.visible = true
	PlayerData.reset() # needs to go somewhere else

func update_interface():
	score.text = "Score: %s" % PlayerData.score
