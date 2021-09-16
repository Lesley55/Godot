extends Node

signal score_updated
signal player_died

var color = Color8(0,0,255,255) # blauw
var playerName = "name" setget set_name
var score = 0 setget set_score

func reset():
	color = Color8(0,0,255,255)
	playerName = "name"
	score = 0

func set_name(value: String):
	value = value.strip_escapes() # remove unwanted escape characters
	value = value.strip_edges() # trim white spaces / unprintable
	if !value.empty() and value != " ":
		playerName = value
	else:
		playerName = "name"

func set_score(value: int):
	score = value
	if score < 0:
		score = 0
	emit_signal("score_updated")

func die():
	emit_signal("player_died")
