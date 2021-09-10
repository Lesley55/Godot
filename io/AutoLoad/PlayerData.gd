extends Node

signal score_updated

var color
var player = "name"
var score = 0 setget set_score

func reset():
#	color = 
	player = "name"
	score = 0

func set_score(value: int):
	score = value
	emit_signal("score_updated")
