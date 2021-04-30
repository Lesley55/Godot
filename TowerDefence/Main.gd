extends Node2D

var mob = preload("res://Mob.tscn")

onready var nav = $Navigation2D
#onready var map = $Navigation2D/Path
onready var start_pos = $start_pos.position
onready var end_pos = $end_pos.position
onready var mob_timer = $mob_timer

signal map_update

func _ready():
	mob_timer.start()

#func _input(event):
#	var tile_pos = map.world_to_map(event.position)
#	if Input.is_action_just_pressed("left_click"):
#		map.set_cell(tile_pos.x, tile_pos.y, 0) # niet zoals ik wil
#		map.update_dirty_quadrants() # update tilemap
#		emit_signal("map_update")
#	if Input.is_action_just_pressed("right_click"):
#		map.set_cell(tile_pos.x, tile_pos.y, -1)
#		map.update_dirty_quadrants() # update tilemap
#		emit_signal("map_update")

func _on_mob_timer_timeout():
	var m = mob.instance()
	add_child(m)
	m.position = start_pos
	m.goal = end_pos
	m.nav = nav
	connect("map_update", m, "update_path")
