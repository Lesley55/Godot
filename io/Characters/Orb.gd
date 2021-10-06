extends KinematicBody2D

const SPEED = 300
const DASHMULTIPLICATION = 6
const DASHFRICTION = 3.0
var size = 1.0
var input_vector = Vector2.DOWN
var split_dash = false
var dash_vector = Vector2.ZERO

onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D
onready var collisionShape = $MeshInstance2D/Area2D/CollisionShape2D
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
	
	# display bigger orbs above smaller orbs / on top
	z_index = size

func move(delta):
	input_vector = input_vector.normalized()
	
	var newSpeed = SPEED
	newSpeed *= (100 - (size * 3)) / 100 # slowing orb if he gets bigger
	
	if split_dash:
		position += dash_vector * delta
		dash_vector = lerp(dash_vector, Vector2.ZERO, DASHFRICTION * delta)
		# stop dash, return to normal movement if dash isn't faster anymore
		var normal = dash_vector.normalized() * newSpeed
		if dash_vector.abs() <= normal.abs():
			split_dash = false
	else:
		# fixing teleport bug when mouse gets to close to middle of player
		if name == "Player":
			var mouse_pos = get_global_mouse_position()
			var dist = mouse_pos.distance_to(global_position)
			if dist < 100:
				newSpeed *= (dist / 100)
		
		# normally you use build in functions like move_and_slide/collide to handle collisions
		# but i need orb to overlap, so changing the position manually
		position += input_vector * newSpeed * delta
#		velocity = move_and_slide(input_vector * SPEED)

# check if there is andy other node like food or orb that can be eaten
func check_for_dinner():
	# get all food nodes
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		# if food in player, eat it
		if area.overlaps_area(food.area):
			if food.size < size:
				var s = food.eat()
				size += s
				if name == "Player":
					PlayerData.score += s * 100
	
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
						var s = orb.eat()
						size += s
						if name == "Player":
							PlayerData.score += s * 100

# slowly reduce player size
func shrink():
	if size > 1:
		# reduce size more when bigger, so won't be able to get infinitely bigger.
		size *= (100 - size / 1000) / 100

func split(delta):
	# can't split infinitely smaller need to be at least bigger than starting size
	if size > 1.2:
		# loose some size for using, then half size
		size = size * 0.985 / 2
		# start timer, to prevent instantly merging again
		timer.start(10)
		# duplicate orb and add to scene
		var orb = .duplicate()
		get_parent().add_child(orb)
		
		# give duplicate the same properties
		orb.position = position
		orb.nameLabelStartPosition = nameLabelStartPosition
		orb.size = size
		
		orb.timer.start(10) # start split timer
		orb.split_dash = true # dash after spitting
		orb.dash_vector = input_vector.normalized() * (SPEED + size) * DASHMULTIPLICATION # dash speed

# check if timer is finished so you can't instantly merge after splitting
func can_be_eaten():
	# ToDo: fix bug, invurnarable after splitting, now you can also not be eaten by an enemy
	return timer.is_stopped()
