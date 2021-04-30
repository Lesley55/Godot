extends Node2D

var rock = preload("res://SpaceJunk/Rock.tscn")
onready var location = $SpaceJunkPath/SpawnLocation

func _ready():
	randomize()

func _on_SpaceJunkTimer_timeout():
	location.unit_offset = randf()
	
	var r = rock.instance()
	add_child(r)
	
	var direction = location.rotation + PI / 2
	r.position = location.position
	direction += rand_range(-PI / 4, PI / 4)
	r.rotation = direction
	
	var velocity = Vector2(rand_range(r.min_speed, r.max_speed), 0)
	r.linear_velocity = velocity.rotated(direction)
