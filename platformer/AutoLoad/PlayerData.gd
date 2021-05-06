extends Node

signal score_updated
signal player_died
signal health_updated
signal max_health_updated

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

var score = 0 setget set_score
var deaths = 0 setget set_deaths

func reset():
	health = max_health
	score = 0

func set_score(value: int):
	score = value
	emit_signal("score_updated")

func set_deaths(value: int):
	deaths = value
	emit_signal("player_died")

func set_health(value):
	health = value
	if health <= 0:
		self.deaths -= 1
	if health > max_health:
		health = max_health
	emit_signal("health_updated", health)

func set_max_health(value):
	max_health = value
	emit_signal("max_health_updated", max_health)

func on_ui_healthbar_ready(): # healthbar not part of player, instances later then playerdata
	emit_signal("max_health_updated", max_health)
