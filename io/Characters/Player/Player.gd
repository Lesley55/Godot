extends "res://Characters/Orb.gd"

signal screen_shake()

var zoom = 1.0

onready var stateMachine = $StateMachine
#onready var camera = $Camera2D

func _ready():
	mesh.modulate = PlayerData.color
	orbName.text = PlayerData.playerName
	
	stateMachine.initialize(stateMachine.START_STATE)

func _process(delta):
	scale()
	move()
	eat()
	shrink()
#	zoom_camera()
	
	if Input.is_action_just_pressed("ui_home"):
		emit_signal("screen_shake")
		queue_free()
		PlayerData.die()

#func zoom_camera():
#	# zoom camera
#	camera.zoom.x = lerp(camera.zoom.x, zoom, 0.05)
#	camera.zoom.y = lerp(camera.zoom.y, zoom, 0.05)
#	# bird view for testing
#	if Input.is_action_pressed("ui_accept"):
#		camera.zoom = Vector2(10, 10)
