extends Node

signal score_updated
signal health_updated
signal max_health_updated
signal no_health
signal player_died

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

var score = 0 setget set_score
var deaths = 0 setget set_deaths
var checkpoint = null

func reset():
	health = max_health
	score = 0

func set_score(value: int):
	score = value
	emit_signal("score_updated")

func set_deaths(value: int):
	deaths = value
	emit_signal("player_died")
	
	# bad code and maybe needs to go somewhere else
	yield(get_tree().create_timer(2.5), "timeout")
	get_tree().reload_current_scene()
	if checkpoint != null:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().current_scene.get_node("Player").position = checkpoint
	get_tree().paused = false

func set_health(value):
	health = value
	if health <= 0:
#		self.deaths -= 1
		emit_signal("no_health")
	if health > max_health:
		health = max_health
		
	var h = health * 0.88 + max_health * 0.09 # correction for missing/transparent pixels in healthbar texture
	emit_signal("health_updated", h)

func set_max_health(value):
	max_health = value
	emit_signal("max_health_updated", max_health)

func on_ui_healthbar_ready(): # healthbar not part of player, instances later then playerdata
	emit_signal("max_health_updated", max_health)
