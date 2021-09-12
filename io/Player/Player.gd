extends Node2D

var size = 1.0
var zoom = 1.0
var speed = 5
var nameStartPosition

onready var camera = $Camera2D
onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D
onready var playerName = $Name # name already exist in higher godot class

func _ready():
	mesh.modulate = PlayerData.color
	playerName.text = PlayerData.playerName
	nameStartPosition = playerName.rect_position

func _process(delta):
	# scale player and name size
	mesh.scale.x = lerp(mesh.scale.x, size, 0.1)
	mesh.scale.y = lerp(mesh.scale.y, size, 0.1)
	playerName.rect_scale.x = lerp(playerName.rect_scale.x, size, 0.1)
	playerName.rect_scale.y = lerp(playerName.rect_scale.y, size, 0.1)
	# scales right down, so adjust position
	playerName.rect_position = nameStartPosition * playerName.rect_scale
	
	# zoom camera
	camera.zoom.x = lerp(camera.zoom.x, zoom, 0.05)
	camera.zoom.y = lerp(camera.zoom.y, zoom, 0.05)
	# bird view for testing
	if Input.is_action_pressed("ui_accept"):
		camera.zoom = Vector2(10, 10)
	
	# move player
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
	
	# slowly reduce player size
	if size > 1:
		size *= 0.99995 # todo replace by changing score
	
	# if food in player, eat it
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		if area.overlaps_area(food):
			if food.size < size:
				size += 0.1 * food.size
				zoom += 0.02 * food.size
				food.eat()
