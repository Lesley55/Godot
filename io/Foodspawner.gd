extends Node2D

var FOOD = preload("res://Food/Food.tscn")
var ENEMY = preload("res://Characters/Enemy/Enemy.tscn")

var size = 1000

onready var bg = $background
onready var border = $Area2D/CollisionPolygon2D

func _ready():
	var width = bg.region_rect.size.x
	var height = bg.region_rect.size.y
	size = width * height
	
	for i in size/100000:
		spawn(FOOD)
	
#	# tried to make map size dynamic, but border collision polygon doesn't update??????
#	border.polygon.set(0, Vector2(-width/2, -height/2))
#	border.polygon.set(0, Vector2(-width/2, height/2))
#	border.polygon.set(0, Vector2(width/2, height/2))
#	border.polygon.set(0, Vector2(width/2, -height/2))

func _process(delta):
	# maybe replace by resetting and changing position, for performance, instead of deleting and adding node?
	if get_child_count() < size/100000:
		spawn(FOOD)
	
	if len(get_tree().get_nodes_in_group("enemy")) < 5:
		spawn(ENEMY)

func spawn(node):
	var n = node.instance()
	add_child(n)
	randomize()
	n.position.x = rand_range(-bg.region_rect.size.x/2, bg.region_rect.size.x/2)
	n.position.y = rand_range(-bg.region_rect.size.y/2, bg.region_rect.size.y/2)
