extends Node2D

var FOOD = preload("res://Food/Food.tscn")
var ENEMY = preload("res://Characters/Enemy/Enemy.tscn")
var PLAYER = preload("res://Characters/Player/Player.tscn")

var size = 1000

onready var bg = $background
onready var border = $Border/CollisionPolygon2D

func _ready():
	# get background size
	var width = bg.region_rect.size.x
	var height = bg.region_rect.size.y
	size = width * height
	
	_spawn(PLAYER)
	
	for i in size/100000:
		_spawn(FOOD)
	
	# update border polygon to match playfield(bg) size
	var polygon = border.get_polygon()
	polygon.set(0, Vector2(-width/2, -height/2))
	polygon.set(1, Vector2(-width/2, height/2))
	polygon.set(2, Vector2(width/2, height/2))
	polygon.set(3, Vector2(width/2, -height/2))
	polygon.set(4, Vector2(-width/2, -height/2))
	border.set_polygon(polygon)

func _process(delta):
	# maybe replace by resetting and changing position, for performance, instead of deleting and adding node?
	if get_child_count() < size/100000:
		_spawn(FOOD)
	
	if len(get_tree().get_nodes_in_group("enemy")) < 5:
		_spawn(ENEMY)

func _spawn(node):
	# instance scene
	var n = node.instance()
	# add node to current level scene
	if node == PLAYER:
		$PlayerOrbs.add_child(n)
	else:
		add_child(n)
	
	# set position
	randomize()
	_change_position(n)
	# don't spawn inside another orb
	if _in_orb(n):
		n.free()
#	# if an orb is already in spawnlocation, change position again
#	while _in_orb(n):
#		_change_position(n)

# check if node is touching an orb
func _in_orb(node):
	var orbs = get_tree().get_nodes_in_group("orb")
	for orb in orbs:
		if node.area.overlaps_area(orb.area):
			return true
	return false

# randomly change position of node in playing field
func _change_position(node):
	node.position.x = rand_range(-bg.region_rect.size.x/2, bg.region_rect.size.x/2)
	node.position.y = rand_range(-bg.region_rect.size.y/2, bg.region_rect.size.y/2)
