extends Node2D

onready var nav = $Navigation2D
onready var ui = $CanvasLayer/UserInterface
onready var player = $Navigation2D/Player
onready var end_pos = $Navigation2D/end_pos
onready var camera = $Camera2D

func _ready():
	get_tree().paused = true
	player.hide()
	end_pos.hide()

# probably shitcode letsgo
func _physics_process(delta):
	var dist = player.position - end_pos.position
	var only_once = true
	if only_once && -20 < dist.x && dist.x < 50 && -20 < dist.y && dist.y < 50:
		only_once = false
		PlayerData.score += 100
		get_tree().change_scene("res://Levels/Labyrint.tscn")

func _on_generating_ended():
	camera.current = true # follow player
	camera.zoom = Vector2(0.5, 0.5) # zoom in on player
	
	get_tree().paused = false
	ui.pause_mode = Node.PAUSE_MODE_PROCESS
	
	player.show()
	end_pos.show()
