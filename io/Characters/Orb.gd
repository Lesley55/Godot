extends KinematicBody2D

var size = 1.0
var speed = 5
var input_vector = Vector2.ZERO

onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D
onready var orbName = $Name
onready var nameLabelStartPosition = orbName.rect_position

func scale():
	# scale orb size
	mesh.scale.x = lerp(mesh.scale.x, size, 0.1)
	mesh.scale.y = lerp(mesh.scale.y, size, 0.1)
	# scale name size
	orbName.rect_scale.x = lerp(orbName.rect_scale.x, size, 0.1)
	orbName.rect_scale.y = lerp(orbName.rect_scale.y, size, 0.1)
	# scales name rightdown, so need to adjust position
	orbName.rect_position = nameLabelStartPosition * orbName.rect_scale

func move():
	# move orb
	var input_vector = Vector2.ZERO
	var mouse_pos = get_global_mouse_position()
	input_vector = global_position - mouse_pos
	input_vector *= -1 # inverted
	input_vector = input_vector.normalized()
	# fixing teleport bug when mouse gets to close to middle of player
	var newSpeed = speed
	var dist = mouse_pos.distance_to(global_position)
	if dist < 100:
		newSpeed *= (dist / 100)
	position += input_vector * newSpeed

func eat():
	# if food in player, eat it
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		if area.overlaps_area(food):
			if food.size < size:
				size += 0.1 * food.size
				food.eat()

func shrink():
	# slowly reduce player size
	if size > 1:
		size *= 0.99995 # todo replace by changing score