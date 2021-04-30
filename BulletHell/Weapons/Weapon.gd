extends Node2D

export(String, FILE) var ammunition = ""
var ammo = null

onready var timer = $Timer
onready var shoot_pos = $Position2D

export var shooting_speed = 0.5

func _ready():
	ammo = load(ammunition)
	timer.wait_time = shooting_speed

func shoot(playerRotation):
	if timer.time_left == 0:
		var a = ammo.instance()
		a.global_position = shoot_pos.global_position
		a.rotation = playerRotation
		get_tree().get_root().add_child(a)
		timer.start(shooting_speed)
