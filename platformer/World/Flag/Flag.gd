extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var particles2D = $Particles2D

func _ready():
	animationPlayer.play("pole")

func _on_Flag_body_entered(body):
	if body.name == "Player":
		PlayerData.checkpoint = position
		animationPlayer.play("flag")
		particles2D.emitting = true
