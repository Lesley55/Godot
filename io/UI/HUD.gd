extends Control

signal screen_shake()

onready var expected = $Expected
onready var score = $Score
onready var overlay = $Overlay
onready var leaderboard = $Overlay/Leaderboard

func _ready():
	# hide overlay by default
	overlay.visible = false
	# load leaderboard data
	GameSaver.load_game(1)
	# connect signals
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	# update player score
	update_interface()

func _on_PlayerData_player_died():
	emit_signal("screen_shake")
	# save player score
	GameSaver.save_game(1)
	# fill leaderboard with data
	leaderboard.update_leaderboard()
	# wait then show overlay
	yield(get_tree().create_timer(1), "timeout")
	overlay.visible = true
	PlayerData.reset() # needs to go somewhere else, hud shouldn't be responsible for this

func update_interface():
	score.text = "Score: %s" % PlayerData.score
	expected.text = "neural network expects\nscore %s\nsurvival time %s" % PlayerData.nn_outputs
