extends Node2D

var food = preload("res://Food/Food.tscn")
onready var bg = $background
onready var border = $Area2D/CollisionPolygon2D

var size = 1000

func _ready():
	var width = bg.region_rect.size.x
	var height = bg.region_rect.size.y
	size = width * height
	
	for i in size/100000:
		spawn_food()
	
#	# tried to make map size dynamic, but border collision polygon doesn't update??????
#	border.polygon.set(0, Vector2(-width/2, -height/2))
#	border.polygon.set(0, Vector2(-width/2, height/2))
#	border.polygon.set(0, Vector2(width/2, height/2))
#	border.polygon.set(0, Vector2(width/2, -height/2))

func _process(delta):
	if get_child_count() < size/100000:
		spawn_food()

func spawn_food():
	var f = food.instance()
	add_child(f)
	randomize()
	f.position.x = rand_range(-bg.region_rect.size.x/2, bg.region_rect.size.x/2)
	f.position.y = rand_range(-bg.region_rect.size.y/2, bg.region_rect.size.y/2)
