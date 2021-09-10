extends Area2D

var size = 1

onready var mesh = $MeshInstance2D
onready var collisionShape = $CollisionShape2D

func _ready():
	randomize()
	size = rand_range(0.2, 0.6)
	mesh.scale = Vector2(size, size)
	collisionShape.scale = Vector2(size, size)
	mesh.modulate = Color8(rand_range(0,255), rand_range(0,255), rand_range(0,255), 255)

func eat():
	queue_free()
