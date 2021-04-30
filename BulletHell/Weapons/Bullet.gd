extends Area2D

export var SPEED = 512
export var damage = 1

func _ready():
	pass # Replace with function body.

func _process(delta):
	var direction = Vector2.UP.rotated(rotation)
	position += direction * SPEED * delta

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("space_junk"):
		body.hit(damage)
		queue_free()
