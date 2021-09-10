extends Node2D

var size = 1.0
var zoom = 1.0
var speed = 5

onready var camera = $Camera2D
onready var mesh = $MeshInstance2D
onready var area = $MeshInstance2D/Area2D

func _process(delta):
	mesh.scale.x = lerp(mesh.scale.x, size, 0.1)
	mesh.scale.y = lerp(mesh.scale.y, size, 0.1)
	
	var input_vector = Vector2.ZERO
	input_vector = global_position - get_global_mouse_position()
	input_vector *= -1 # inverted
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
#	removing teleportation when mouse in player
	position += input_vector * speed
	
	camera.zoom.x = lerp(camera.zoom.x, zoom, 0.05)
	camera.zoom.y = lerp(camera.zoom.y, zoom, 0.05)
	if Input.is_action_pressed("ui_accept"):
		camera.zoom = Vector2(10, 10)
	
	if size > 1:
		size *= 0.99995
	
	var foods = get_tree().get_nodes_in_group("food")
	for food in foods:
		if area.overlaps_area(food):
			if food.size < size:
				size += 0.1 * food.size
				zoom += 0.02 * food.size
				food.eat()
