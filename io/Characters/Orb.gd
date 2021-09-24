extends KinematicBody2D

# preloading scene for when we need to instance a new one when splitting
#var ENEMY = preload("res://Characters/Enemy/Enemy.tscn")
#var PLAYER = preload("res://Characters/Player/Player.tscn")

const SPEED = 300
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

func move(delta):
#	# fixing teleport bug when mouse gets to close to middle of player
#	var newSpeed = SPEED
#	newSpeed *= (100 - (size * 8)) / 100 # slowing player if he gets bigger
#	var dist = mouse_pos.distance_to(global_position)
#	if dist < 100:
#		newSpeed *= (dist / 100)
#	position += input_vector * newSpeed
	input_vector = input_vector.normalized()
	position += input_vector * SPEED * delta

func check_for_dinner():
	# get all food nodes
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		# if food in player, eat it
		if area.overlaps_area(food.area):
			if food.size < size:
				size += food.eat()
	
	# get all orbs
	var orbs = get_tree().get_nodes_in_group("orb")
	for orb in orbs:
		if area.overlaps_area(orb.area):
			# distance between positions
			var distance = global_position.distance_to(orb.global_position)
			# only eat if at least overlapping half in diameter
			if distance < size * mesh.mesh.radius:
				# at least % bigger, so not unfair if both players are almost equal sized
				if orb.size * 1.04 < size:
					# can't instantly merge after splitting
					if orb.can_be_eaten():
						# eat orb/enemy
						size += orb.eat()

func shrink():
	# slowly reduce player size
	if size > 1:
		size *= 0.99995

func split(delta):
	# can't split infinitely smaller need to be at least bigger than starting size
	if size > 1.2:
		# loose some size for using, then half size
		size = size * 0.97 / 2
		# start timer, to prevent instantly merging again
		timer.start(10)
		# duplicate orb and add to scene
		var orb = .duplicate()
		get_parent().add_child(orb)
		# give duplicate the same properties
		orb.position = position + input_vector * SPEED * size * 100 * delta
		orb.nameLabelStartPosition = nameLabelStartPosition
		orb.size = size
		orb.timer.start(10)

func can_be_eaten():
	return timer.is_stopped()
