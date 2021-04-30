extends Control

onready var scene_tree = get_tree()
onready var score = $Score
onready var pause_overlay = $PauseOverlay
onready var label = $PauseOverlay/Panel/Title
onready var health_bar = $HealthBar
onready var low_health_pulse = $LowHealthPulse

var paused = false setget set_paused

const DIED_MESSAGE = "You died"

func _ready():
	pause_overlay.visible = false
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("health_updated", health_bar, "_on_health_updated")
	PlayerData.connect("max_health_updated", health_bar, "_on_max_health_updated")
	PlayerData.on_ui_healthbar_ready() # healthbar not part of player, instances later then playerdata
	update_interface()

func _on_PlayerData_player_died():
	label.text = DIED_MESSAGE
	self.paused = true
	PlayerData.reset() # needs to go somewhere else

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
