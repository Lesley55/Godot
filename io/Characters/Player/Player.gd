extends "res://Characters/Orb.gd"

signal screen_shake()

onready var stateMachine = $StateMachine

func _ready():
	mesh.modulate = PlayerData.color
	orbName.text = PlayerData.playerName
	
	stateMachine.initialize(stateMachine.START_STATE)

func _process(delta):
	scale()
	move()
	eat()
	shrink()
	
	if Input.is_action_just_pressed("ui_home"):
		emit_signal("screen_shake")
		queue_free()
		PlayerData.die()
