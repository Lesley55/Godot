extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
export var damage = 1

onready var stats = $Stats

func hit(amount):
	PlayerData.score += 10
	stats.health -= amount

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Stats_no_health():
	queue_free()
