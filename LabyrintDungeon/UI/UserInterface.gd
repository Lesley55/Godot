extends Control

onready var scene_tree = get_tree()
onready var score = $Score
onready var pause_overlay = $PauseOverlay
onready var label = $PauseOverlay/Panel/Title

var paused = false setget set_paused

const DIED_MESSAGE = "You died"

func _ready():
	pause_overlay.visible = false
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()

func _on_PlayerData_player_died():
	self.paused = true
	label.text = DIED_MESSAGE

func _unhandled_input(event):
	if event.is_action_pressed("pause") and label.text != DIED_MESSAGE:
		self.paused = not paused
		scene_tree.set_input_as_handled()

func update_interface():
	score.text = "Score: %s" % PlayerData.score

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
