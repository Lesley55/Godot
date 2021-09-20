extends KinematicBody2D

# preloading scene for when we need to instance a new one when splitting
#var ENEMY = preload("res://Characters/Enemy/Enemy.tscn")
#var PLAYER = preload("res://Characters/Player/Player.tscn")

const SPEED = 5
var size = 1.0
var input_vector = Vector2.ZERO

onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D
onready var orbName = $Name
onready var nameLabelStartPosition = orbName.rect_position
onready var timer = $Timer

func scale():
	# scale orb size
	mesh.scale.x = lerp(mesh.scale.x, size, 0.1)
	mesh.scale.y = lerp(mesh.scale.y, size, 0.1)
	# scale name size
	orbName.rect_scale.x = lerp(orbName.rect_scale.x, size, 0.1)
	orbName.rect_scale.y = lerp(orbName.rect_scale.y, size, 0.1)
	# name scales rightdown, so need to adjust position
	orbName.rect_position = nameLabelStartPosition * orbName.rect_scale

func move():
	# move orb
	var mouse_pos = get_global_mouse_position()
	input_vector = global_position - mouse_pos
	input_vector *= -1 # inverted
	input_vector = input_vector.normalized()
	# fixing teleport bug when mouse gets to close to middle of player
	var newSpeed = SPEED
	newSpeed *= (100 - (size * 8)) / 100 # slowing player if he gets bigger
	var dist = mouse_pos.distance_to(global_position)
	if dist < 100:
		newSpeed *= (dist / 100)
	position += input_vector * newSpeed

func check_for_dinner():
	# if food in player, eat it
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		if area.overlaps_area(food):
			if food.size < size:
				size += food.eat()
	
	var orbs = get_tree().get_nodes_in_group("orb")
	for orb in orbs:
		if area.overlaps_area(orb.area):
			# at least % bigger, so not unfair if both players are almost equal sized
			if orb.size * 1.04 < size:
				# can't instantly merge after splitting
				if orb.timer.is_stopped():
					size += orb.eat()

func shrink():
	# slowly reduce player size
	if size > 1:
		size *= 0.99995 # todo replace by changing score

func split():
	if size > 1.2:
		size = size * 0.95 / 2
		timer.start(10)
#		var orb = node.instance()
		var orb = .duplicate()
		get_parent().add_child(orb)
		orb.position = position + input_vector * SPEED * size * 100
		orb.nameLabelStartPosition = nameLabelStartPosition
		orb.size = size
		orb.timer.start(10)
