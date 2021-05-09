extends Node

signal health_updated
signal max_health_updated
signal no_health

export(int) var max_health = 1
onready var health = max_health setget set_health

func _ready():
	emit_signal("max_health_updated", max_health)

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
	if health > max_health:
		health = max_health
	
	var h = health * 0.88 + max_health * 0.09 # correction for missing/transparent pixels in healthbar texture
	emit_signal("health_updated", h)
