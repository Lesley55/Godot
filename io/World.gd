extends Node2D

# should be const but can't, because need to load the scene so it changes in the beginning
var FOOD = preload("res://Food/Food.tscn")
var ENEMY = preload("res://Characters/Enemy/Enemy.tscn")
var PLAYER = preload("res://Characters/Player/Player.tscn")

var width = 10000
var height = 10000
var size = 100000000

var amount_of_food = 1000
var amount_of_enemies = 20

onready var bg = $background
onready var border = $Border/CollisionPolygon2D

func _ready():
	# randomize values
	randomize()
	width = rand_range(5000, 15000)
	height = rand_range(5000, 15000)
	amount_of_food = rand_range(500, 2000)
	amount_of_enemies = rand_range(5, 25)
	# save data to use as input for neural network # devided by max to get a relative value between 0 and 1
	PlayerData.set_nn_inputs([width/15000, height/15000, amount_of_food/2000, amount_of_enemies/25])
	
	# get background size
	bg.region_rect.size.x = width
	bg.region_rect.size.y = height
	size = width * height
	
	_spawn(PLAYER)
	
	for i in amount_of_food:
		_spawn(FOOD)
	
	for i in amount_of_enemies:
		_spawn(ENEMY)
	
	# update border polygon to match playfield(bg) size
	var polygon = border.get_polygon()
	polygon.set(0, Vector2(-width/2, -height/2))
	polygon.set(1, Vector2(-width/2, height/2))
	polygon.set(2, Vector2(width/2, height/2))
	polygon.set(3, Vector2(width/2, -height/2))
	polygon.set(4, Vector2(-width/2, -height/2))
	border.set_polygon(polygon)

func _process(_delta):
	# maybe replace by resetting and changing position, for performance, instead of deleting and adding node?
	if len(get_tree().get_nodes_in_group("food")) < amount_of_food:
#	if get_child_count() < amount_of_food: # almost same amount but might be more performant? idk
		_spawn(FOOD)
	
	if len(get_tree().get_nodes_in_group("enemy")) < amount_of_enemies:
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
