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
	check_for_dinner()
	shrink()
	
	# test
	if Input.is_action_just_pressed("ui_home"):
		queue_free()
	if Input.is_action_just_pressed("ui_page_up"):
		split()

func eat():
	queue_free()
	return size * 0.5
